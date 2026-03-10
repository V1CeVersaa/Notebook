# Solidity

!!! Info "What is Solidity?"
    Solidity is an object-oriented, high-level language for implementing smart contracts. Smart contracts are programs that govern the behavior of accounts within the Ethereum state.

    Solidity is a curly-bracket language designed to target the Ethereum Virtual Machine (EVM). It is influenced by C++, Python, and JavaScript. You can find more details about which languages Solidity has been inspired by in the language influences section.

    Solidity is statically typed, supports inheritance, libraries, and complex user-defined types, among other features.

    说白了，Solidity 其实就是一种智能合约编程语言，特别是以太坊的官方语言。

    参考：

    - [Solidity - Solidity 0.8.26 documentation](https://docs.soliditylang.org/en/v0.8.26/)
    - [xg 的 Solidity 笔记](https://note.tonycrane.cc/ctf/blockchain/eth/solidity/)

## 1 结构

## 2 数据类型

Solidity 是一个静态类型语言，并且没有 `null` 或 `undefined` 类型，取而代之的是默认值：每个新建的变量依据其类型都会有一个默认值。

### 2.1 数值类型

1. 布尔类型/Boolean：

    - 取值：`true` 与 `false`；
    - 支持运算：`||`、`&&`、`!`、`==`、`!=`。

2. 整数类型/Integer：

3. 定点数类型/Fixed Point Numbers：

4. 地址类型/Address：

5. 定长字节数组/Fixed-size Byte Arrays：

6. 枚举类型/Enum：

7. 用户自定义类型/User-defined Value Types：

8. 合约类型/Contract：

### 2.2 函数类型

其实函数类型也隶属于数值类型 QAQ，但是单提出来了。

### 2.3 引用类型

### 2.4 映射类型

映射/Mapping 的语法是 `#!solidity mapping(KeyType KeyName? => ValueType ValueName?) VariableName`，其中 `KeyName` 和 `ValueName` 可以省略。键的类型只能是内置类型，比如 bytes、address、contact、enum 等，但是值的类型就可以是任意类型了，用户自定义类型也可以。

给映射新增的键值对的语法为 `_Var[_Key] = _Value`，其中 `_Var` 是映射变量名，`_Key` 和 `_Value` 对应新增的键值对。

映射类型**不存储键**，使用 `keccak256(abi.encodePacked(key, slot))` 当成 offset 存取 value，`slot` 是映射变量定义所在的插槽位置。因而映射类型没有长度属性。

映射中未初始化的值会被初始化为其类型的默认值。

映射的存储位置必须是 `storage`，因此可以用于合约的状态变量，函数中的 `storage` 变量，和 library 函数的参数。不能用于 `public` 函数的参数或返回结果中，因为 `mapping` 记录的是一种关系（键值对）。

如果映射声明为 `public`，那么 solidity 会自动给你创建一个 `getter` 函数，可以通过 `Key` 来查询对应的 `Value`，比如文档中的例子：

```solidity
contract MappingExample {
    mapping(address addr => uint balance) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    function f() public returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(address(this));
    }
}
```

尽管一般的映射没法遍历，因为没法枚举键，但是我们可以建立一个在映射之上的数据结构，这样间接对映射进行遍历，就实现了 Iterable Mapping，下面是实现：

??? Info "Implementation of Iterable Mapping"

    ```solidity
    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.8;

    struct IndexValue { uint keyIndex; uint value; }
    struct KeyFlag { uint key; bool deleted; }

    struct itmap {
        mapping(uint => IndexValue) data;
        KeyFlag[] keys;
        uint size;
    }

    type Iterator is uint;

    library IterableMapping {
        function insert(itmap storage self, uint key, uint value) internal returns (bool replaced) {
            uint keyIndex = self.data[key].keyIndex;
            self.data[key].value = value;
            if (keyIndex > 0)
                return true;
            else {
                keyIndex = self.keys.length;
                self.keys.push();
                self.data[key].keyIndex = keyIndex + 1;
                self.keys[keyIndex].key = key;
                self.size++;
                return false;
            }
        }

        function remove(itmap storage self, uint key) internal returns (bool success) {
            uint keyIndex = self.data[key].keyIndex;
            if (keyIndex == 0)
                return false;
            delete self.data[key];
            self.keys[keyIndex - 1].deleted = true;
            self.size --;
        }

        function contains(itmap storage self, uint key) internal view returns (bool) {
            return self.data[key].keyIndex > 0;
        }

        function iterateStart(itmap storage self) internal view returns (Iterator) {
            return iteratorSkipDeleted(self, 0);
        }

        function iterateValid(itmap storage self, Iterator iterator) internal view returns (bool) {
            return Iterator.unwrap(iterator) < self.keys.length;
        }

        function iterateNext(itmap storage self, Iterator iterator) internal view returns (Iterator) {
            return iteratorSkipDeleted(self, Iterator.unwrap(iterator) + 1);
        }

        function iterateGet(itmap storage self, Iterator iterator) internal view returns (uint key, uint value) {
            uint keyIndex = Iterator.unwrap(iterator);
            key = self.keys[keyIndex].key;
            value = self.data[key].value;
        }

        function iteratorSkipDeleted(itmap storage self, uint keyIndex) private view returns (Iterator) {
            while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
                keyIndex++;
            return Iterator.wrap(keyIndex);
        }
    }

    // How to use it
    contract User {
        // Just a struct holding our data.
        itmap data;
        // Apply library functions to the data type.
        using IterableMapping for itmap;

        // Insert something
        function insert(uint k, uint v) public returns (uint size) {
            // This calls IterableMapping.insert(data, k, v)
            data.insert(k, v);
            // We can still access members of the struct,
            // but we should take care not to mess with them.
            return data.size;
        }

        // Computes the sum of all stored data.
        function sum() public view returns (uint s) {
            for (
                Iterator i = data.iterateStart();
                data.iterateValid(i);
                i = data.iterateNext(i)
            ) {
                (, uint value) = data.iterateGet(i);
                s += value;
            }
        }
    }
    ```


### 2.5 运算符

## 3 单位与变量

## 4 表达式与控制流


## 5 合约
