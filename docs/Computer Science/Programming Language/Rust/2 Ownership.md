# Ownership and Memory Management

## 1. What is Ownership

## 2. References and Borrowing

## 3. The Slice Type

## 4. `Box` Smart Pointer

`Deref`

`Drop`

`Cow` `Borrow` `Owned`

## 5. `Rc` Reference Counting

当我们希望在堆上分配一个对象供程序的多个部分使用，且无法确定哪一个部分最后一个结束的时候，就可以使用 `Rc` 作为数据值的所有者。

```rs
use std::rc::Rc;

let a = Rc::new(String::from("Hello"));
let b = a.clone();
```

- `Rc<T>` 是指向底层数据的**不可变引用**，因此我们无法修改底层数据，其也只支持单线程使用，多线程需要使用 `Arc<T>`，需要修改就必须使用 `RefCell<T>` 或者 `Mutex<T>`。
- 当智能指针 `Rc<T>` 创建的时候，引用计数就会加一，我们使用引用计数的关联函数 `Rc::strong_count` 来查看引用计数。
- `Rc::clone` 克隆智能指针，并且增加引用计数，但是这里的 `clone` 仅仅复制指针，但是没有克隆底层数据。
- 智能指针的引用计数会随着智能指针离开作用域被自动释放或者手动释放而变化，一旦最后一个拥有者小时，资源就会自动消失，其生命周期是在编译期就确定下来的。

`Arc` 是 `Rc` 的线程安全版本，其是 Atomic Rc 的缩写，允许数据可以安全的在线程之间共享，其 API 与 `Rc` 完全相同，修改非常简单，只需要从 `std::rc::Rc` 修改为 `std::sync::Arc` 即可。

```rs
use std::sync::Arc;
use std::thread;

fn main() {
    let s = Arc::new(String::from("Multi-threaded Wanderer"));
    for _ in 0..10 {
        let s = Arc::clone(&s);
        let handle = thread::spawn(move || {
           println!("{}", s)
        });
    }
}
```

## 6. `RefCell` and Interior Mutability



## 7. Memory Leaks and Reference Cycles

## 8. Drop Trait and RAII
