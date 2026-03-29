# Javascript

可以使用 `<script>` 标签将 JavaScript 代码插入到 HTML 页面中，如果指定了 `src` 属性，就可以将外部的 JavaScript 文件引入到 HTML 页面中，同时 `<script>` 标签内的代码就会被忽略，一个单独的 `<script>` 标签不可以同时有 `src` 属性和内部代码。

```html
<script src="script.js"></script>
<script> alert('Hello, World!'); </script>
```

???- Info "一些妙妙小东西"
    学在浙大课件下载，打开开发者工具，复制代码到控制台运行则可：

    ```Javascript
    var src = document.getElementById('pdf-viewer').getAttribute('ng-src')
    var url = unescape(src).replace(/.+(http.+)(&upload_id.+)/, '$1')
    window.location.href = url
    ```

## 数据类型

使用 `let` 或者 `var` 来创建一个变量，但是现代一般使用 `let`，比如 `let message` 就创建了一个名为 `message` 的变量，`message = "hello"` 就将 `message` 赋值成为 `hello`，变量名可以包含字母、数字、下划线和美元符号，甚至可以有非英文字母，但是不能以数字开头，同时推荐使用驼峰命名法。

不允许连续声明同一个变量，变量的值可以随时改变，JavaScript 是一种动态类型语言，变量的类型可以随时改变。

使用 `const` 可以创建一个常量，比如 `const BIRTHDAY = "28.08.2005"` 就创建了一个常量，常量不可以被修改。

在下面的例子中，由于`admin` 只是保存了 `name` 的值，而不是 `name` 的引用，所以第二次会输出 `John`，而不是 `susy`。

```javascript
let name = "John", admin = name;
console.log(admin);
name = "susy";
console.log(admin);
```

### 1. 数字类型

## 表达式与运算符

### 1. 运算符

- 自增/自减运算符：可以放在变量的前面或者后面，并根据运算符的位置返回自减/自增之前或之后的值。自增/自减运算符只能应用于引用的操作数（也就是有效的赋值目标），因此不能将多个自增/自减运算符链接在一起。
- 一元运算符 `+` 和 `-`：将操作数转换为 `Number` 类型，`-` 会将操作数转换为负数。

## 3. 语句、声明与控制流

## 4. 函数

## 5. 对象

