# Pytorch

## Table of Contents

- [ ] [Tensor with Operations](./Tensor.md)

先在这随便记一点

> [PyTorch Internals](http://blog.ezyang.com/2019/05/pytorch-internals/)

## Table of Contents

Slicing a tensor returns a **view** into the same data, so modifying it will also modify the original tensor. To avoid this, you can use the `clone()` method to make a copy of a tensor.

```python
a = torch.tensor([[1, 2, 3, 4], [5, 6, 7, 8]])
b = a[0, 1:]
b[0] = 0
print(a)

# tensor([[1, 0, 3, 4],
#         [5, 6, 7, 8]])
```

切片操作创建的是原始数据的"视图"(view)
视图和原始tensor共享相同的内存空间
这样做可以节省内存，提高效率
但也意味着修改视图会影响原始数据

`view()` 是 PyTorch 中用来改变张量形状的一个函数，一个重要作用是在不改变张量数据的情况下，返回一个具有不同形状的新张量视图。特点如下：

- 共享内存：`view()` 返回的新张量与原始张量共享底层数据，这意味着对新张量的修改会影响原始张量，对两个张量使用 `data_ptr()` 可以验证这一点；
- 元素数量不变：`view()` 操作前后，张量中的元素总数必须保持不变，我们可以在 `view()` 中使用 `-1` 参数，PyTorch 会自动计算该维度的大小，使得总元素数量保持不变；
- 连续性要求：`view()` 要求张量必须是连续的/Contiguous。如果张量不连续，需要先调用 `.contiguous()` 或使用 `.reshape()` 替代。
- 按照行优先处理元素，因此不能用于矩阵转置，对于转置操作，应使用 `.t()`、`.transpose()` 或 `.permute()`。

```python
x0 = torch.randn(2, 3, 4)
x1 = x0.transpose(1, 2).view(8, 3)                  # 不连续，RuntimeError
x2 = x0.transpose(1, 2).contiguous().view(8, 3)     # 连续
```
