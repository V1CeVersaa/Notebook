# 属性描述符、原型与 Class

<!-- Source: https://javascript.info/object-properties, https://javascript.info/prototypes, https://javascript.info/classes -->

!!! Abstract "Outline"

    JavaScript 的 class 建在原型模型上。先把属性描述符、prototype lookup 和 method dispatch 看明白，再看 class inheritance、private fields、`instanceof` 和 mixin，很多“像 Java 但又不太像”的地方就不奇怪了。

    - [x] [1. Property descriptor 与 getter/setter](#chapter-model-descriptor)
    - [x] [2. Prototype lookup 与 `F.prototype`](#chapter-model-prototype)
    - [x] [3. Native prototype 与 object without `__proto__`](#chapter-model-native)
    - [x] [4. Class syntax、constructor 与 method](#chapter-model-class)
    - [x] [5. Inheritance、static、private fields 与 built-ins](#chapter-model-inheritance)
    - [x] [6. `instanceof`、mixin 与插件里的对象边界](#chapter-model-instanceof)

## 1. Property descriptor 与 getter/setter { #chapter-model-descriptor }

对象属性不是简单的 key 到 value 映射。每个属性背后都有属性描述符/Property Descriptor。数据属性/Data Property 有 `value`、`writable`、`enumerable`、`configurable` 四个字段。

```js
const user = {};

Object.defineProperty(user, "id", {
  value: "u1",
  writable: false,
  enumerable: true,
  configurable: false,
});
```

`writable: false` 表示不能改值；`enumerable: false` 表示不会出现在 `Object.keys`、`for...in` 和对象 spread 这类枚举里；`configurable: false` 表示不能删除，也不能再随意改描述符。普通对象字面量创建的属性默认都是 writable、enumerable、configurable。

这个机制解释了很多“为什么看得到但遍历不到”的现象。对象方法、内置属性、class 原型方法通常是 non-enumerable，所以 `for...in` 不会把方法全扫出来。要看描述符，用 `Object.getOwnPropertyDescriptor`。

```js
Object.getOwnPropertyDescriptor(user, "id");
```

访问器属性/Accessor Property 没有 `value` 和 `writable`，而是 `get` 和 `set`。读取属性时调用 getter，赋值时调用 setter。外部看起来像属性，内部可以计算、校验或同步状态。

```js
const user = {
  firstName: "Ada",
  lastName: "Lovelace",

  get fullName() {
    return `${this.firstName} ${this.lastName}`;
  },

  set fullName(value) {
    [this.firstName, this.lastName] = value.split(" ");
  },
};
```

getter 最好保持轻量、少副作用，因为调用点看起来只是属性读取。把昂贵 I/O、异步逻辑或会抛复杂异常的行为藏进 getter，调试时很难第一眼看出问题。需要异步就写方法；JavaScript 语法也不支持 `async get` 返回“await 后的属性值”这种模型。

对象冻结和密封也是描述符层面的操作。`Object.preventExtensions` 禁止新增属性；`Object.seal` 禁止新增和删除，并把现有属性设为 non-configurable；`Object.freeze` 进一步把数据属性设为 non-writable。它们都是浅层操作，不会递归冻结嵌套对象。

```js
const config = Object.freeze({
  ui: { theme: "dark" },
});

config.ui.theme = "light"; // inner object still mutable
```

## 2. Prototype lookup 与 `F.prototype` { #chapter-model-prototype }

JavaScript 对象有一个内部槽 `[[Prototype]]`，指向另一个对象或 `null`。读取属性时，引擎先查对象自身属性；找不到就沿 `[[Prototype]]` 往上查；直到 `null` 停止。这条查找路径就是原型链/Prototype Chain。

```js
const animal = {
  eats: true,
};

const rabbit = {
  jumps: true,
  __proto__: animal,
};

rabbit.eats; // true
```

`__proto__` 是历史访问器，不是推荐的核心 API。现代代码更应该用 `Object.getPrototypeOf(obj)` 和 `Object.setPrototypeOf(obj, proto)`，或者在创建时用 `Object.create(proto)`。频繁动态改 prototype 会让引擎优化失效，业务代码里应尽量在对象创建时确定。

```js
const rabbit = Object.create(animal);
rabbit.jumps = true;
```

原型链只影响属性查找，不改变 `this`。如果方法来自 prototype，调用表达式的 base object 仍然决定 `this`。

```js
const animal = {
  walk() {
    return this.name;
  },
};

const rabbit = Object.create(animal);
rabbit.name = "White Rabbit";
rabbit.walk(); // "White Rabbit"
```

这里要分清两个动作：方法沿原型链找到，调用时的 `this` 仍然是点号左边的 `rabbit`。原型方法因此可以共享行为，同时作用于具体实例状态。

构造函数的 `prototype` 属性参与 `new`。如果调用 `new User()`，新对象的 `[[Prototype]]` 会被设置为 `User.prototype`。注意 `User.prototype` 是函数对象的一个普通属性，不是函数自己的 `[[Prototype]]`。

```js
function User(name) {
  this.name = name;
}

User.prototype.sayHi = function () {
  return this.name;
};

const ada = new User("Ada");
Object.getPrototypeOf(ada) === User.prototype; // true
```

默认的 `F.prototype` 有一个 `constructor` 属性指回函数本身。重写整个 prototype 对象时，如果不恢复 `constructor`，某些反射代码会得到不完整的信息。

```js
User.prototype = {
  constructor: User,
  sayHi() {
    return this.name;
  },
};
```

## 3. Native prototype 与 object without `__proto__` { #chapter-model-native }

数组方法来自 `Array.prototype`，字符串方法来自 `String.prototype`，普通对象方法来自 `Object.prototype`。所以数组实例本身没有 `map` 自有属性，也照样能调用 `arr.map(...)`。

```js
const arr = [1, 2, 3];
arr.hasOwnProperty("map"); // false
"map" in arr;              // true
```

修改 native prototype 在语言上可行，在应用代码里基本不该做。给 `Array.prototype` 加方法会影响所有数组，可能和未来标准、新版本依赖或其他插件冲突。Polyfill 是少数例外，也应该精确检查环境并遵守标准行为。

普通对象继承自 `Object.prototype`，这意味着它天然带有 `toString`、`hasOwnProperty` 等方法，也意味着某些属性名可能和原型属性发生关系。作为纯 dictionary 使用时，可以创建没有 prototype 的对象。

```js
const dict = Object.create(null);
dict["__proto__"] = "safe data";
```

这种 object without prototype 没有 `hasOwnProperty` 方法，要用 `Object.hasOwn(dict, key)` 或 `Object.prototype.hasOwnProperty.call(dict, key)`。现代代码优先用 `Object.hasOwn`，表达更直接。

```js
Object.hasOwn(dict, "__proto__");
```

原型链和枚举也要分开。`for...in` 会枚举可枚举的自有属性和继承属性；`Object.keys` 只返回可枚举自有属性；`Reflect.ownKeys` 返回自有 string key 和 symbol key，包括 non-enumerable。写对象遍历时要先想清楚要不要继承属性。

```js
for (const key in obj) {
  if (Object.hasOwn(obj, key)) {
    // own enumerable property only
  }
}
```

## 4. Class syntax、constructor 与 method { #chapter-model-class }

`class` 是构造函数和 prototype method 的语法层。它让写法更接近传统 OOP，但运行模型仍然是 prototype。

```js
class User {
  constructor(name) {
    this.name = name;
  }

  sayHi() {
    return this.name;
  }
}

const user = new User("Ada");
Object.getPrototypeOf(user) === User.prototype; // true
```

class body 自动使用 strict mode。class 必须用 `new` 调用，不能像普通函数一样裸调用。class method 默认是 non-enumerable，这比手动给 prototype 赋值更接近内置对象行为。

```js
User("Ada"); // TypeError
```

class declaration 和 `let`/`const` 类似，也有 temporal dead zone，不能在声明前使用。它不像函数声明那样可以随处提升。

```js
// new Task(); // ReferenceError

class Task {}
```

Class fields 是在实例上定义属性，不是在 prototype 上。方法在 prototype 上共享，字段在每个实例上各有一份。箭头函数字段常用于自动绑定实例 `this`，代价是每个实例都会创建一个新函数。

```js
class Controller {
  name = "demo";

  run = () => {
    return this.name;
  };
}
```

这种写法在 React 旧代码和某些 callback-heavy 类里常见。VSCode 插件里如果实例数量很少，它是合理的；如果会创建大量对象，prototype method 加构造器里一次性 `bind` 更可控。

## 5. Inheritance、static、private fields 与 built-ins { #chapter-model-inheritance }

`extends` 建立两条关系：实例原型链和构造函数原型链。实例方法沿 `Child.prototype -> Parent.prototype` 查找；静态方法沿 `Child -> Parent` 查找。`super.method()` 会在父类原型上找方法，并以当前 `this` 调用它。

```js
class Animal {
  walk() {
    return "walk";
  }
}

class Rabbit extends Animal {
  walk() {
    return `${super.walk()} and jump`;
  }
}
```

派生类构造器里必须先调用 `super()`，才能使用 `this`。因为 `this` 的创建由父类构造过程完成，子类在 `super()` 前没有可用实例。

```js
class Rabbit extends Animal {
  constructor(name) {
    super();
    this.name = name;
  }
}
```

Static properties 和 static methods 属于类构造函数本身，不属于实例。factory、registry、常量、纯工具行为都可以放在 static 侧。

```js
class Command {
  static prefix = "demo";

  static id(name) {
    return `${this.prefix}.${name}`;
  }
}
```

这里 `this` 在 static method 里指向类本身。子类调用继承的 static method 时，`this` 可以是子类，这让 factory method 能在继承层级里保持多态。

Private fields 以 `#` 开头，是语言级私有，不是 TypeScript 的编译期 private，也不是命名约定。类外部不能访问，甚至不能用 `obj["#field"]` 绕过。

```js
class Counter {
  #value = 0;

  increment() {
    this.#value += 1;
    return this.#value;
  }
}
```

`#private` 的硬边界适合内部状态，但它也降低测试和调试时的可见性。库内部不变量很适合用它；普通插件代码要先想清楚，这个状态是否真的需要语言级封闭。

现代 JS 可以继承 built-in classes，例如继承 `Error` 或 `Array`。最常见、也最值得做的是自定义错误类型；继承 `Array` 这类容器通常不如组合清楚。

```js
class ExtensionError extends Error {
  constructor(message, code) {
    super(message);
    this.name = "ExtensionError";
    this.code = code;
  }
}
```

继承内置类时要确认 `super` 正确初始化了内置内部槽。自定义 `Error` 时设置 `name` 能让日志和 stack trace 更好读。

## 6. `instanceof`、mixin 与插件里的对象边界 { #chapter-model-instanceof }

`obj instanceof Class` 会检查 `Class.prototype` 是否出现在 `obj` 的原型链上。它不是结构类型检查，也不是“这个对象长得像某类”的判断。

```js
user instanceof User;
```

这有两个边界。第一，跨 realm 的对象可能来自不同全局环境，构造函数身份不同，`instanceof Array` 这类检查可能失效；更稳的是 `Array.isArray(value)`。第二，普通 JSON parse 出来的对象没有你的 class prototype，即使字段完全一样，也不是实例。

```js
const raw = JSON.parse('{"name":"Ada"}');
raw instanceof User; // false
```

需要结构检查时，直接检查属性或写 schema validator。TypeScript 的类型也只存在于编译期，运行时不会替你做 `instanceof`。

`Symbol.hasInstance` 可以自定义 `instanceof` 行为，但日常业务代码很少需要它。它会把一个直接的原型链检查变成任意逻辑，维护成本高。

Mixin 是把一组方法复制或组合进类的模式。JS 没有多继承，但可以用函数接收基类并返回扩展后的子类。

```js
const DisposableMixin = (Base) =>
  class extends Base {
    disposables = [];

    dispose() {
      for (const item of this.disposables) {
        item.dispose();
      }
    }
  };

class Controller extends DisposableMixin(Object) {}
```

Mixin 适合横切能力，例如 disposable 管理、event emitting、logging。缺点是方法来源不如显式组合清楚，命名冲突也更隐蔽。插件代码里，如果只是共享一个 `disposeAll` 工具函数，普通函数比 mixin 更简单；只有多个类确实共享一组状态和方法时，mixin 才值得上。

JavaScript 对象模型要优先按**属性查找和函数调用**来读。class 能让代码更整齐，但不会改掉几件底层事实：`this` 由调用点决定，方法来自 prototype，对象按引用共享。
