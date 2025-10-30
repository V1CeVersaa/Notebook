# Tensors and Their Operations

## Shape Operations

### `squeeze` & `unsqueeze`

- `#!py torch.squeeze(input: Tensor, dim: Optional[int, List[int]] = None) -> Tensor`
- `#!py torch.unsqueeze(input: Tensor, dim: int) -> Tensor`

`torch.squeeze` 移除张量形状中为 1 的维度/Singleton Dimensions，比如将形状为 `(1, 3, 1, 5)` 的张量变为 `(3, 5)`。添加参数 `torch.squeeze(dim)` 可以指定移除特定参数。**但是，其返回的张量和输入的张量共享存储，因此改变其中一个的内容会改变另外一个的内容**。

```python
a = torch.tensor([[1, 2, 3, 4], [5, 6, 7, 8]])
b = a.squeeze()
c = a.unsqueeze(dim=1)

print(b)
# tensor([1, 2, 3, 4, 5, 6, 7, 8])
print(c)
# tensor([[[1, 2, 3, 4]],
#         [[5, 6, 7, 8]]])
```

### `repeat` & `expand`

- `#!py torch.repeat(input: Tensor, *repeats) -> Tensor`
- `#!py torch.expand(input: Tensor, *sizes) -> Tensor`

`torch.repeat` 和 `torch.expand` 都是用于扩展张量的维度，但是 `torch.repeat` 是用于重复张量的元素，而 `torch.expand` 是用于扩展张量的维度（只能处理 Singleton Dimensions 也就是形状中为 1 的维度），并且返回一个**新的 view**。需要注意的是，扩展张量中的多个元素可能指向内存中的同一个位置，因此原地操作可能会导致不正确的结果。

```python
a = torch.tensor([[1, 2], [3, 4]])
b = a.repeat([2, 3])
c = a.repeat([2, 1, 2])
d = torch.tensor([1, 2, 3])
e = d.unsqueeze(dim=1).expand([3, 2])

print(b)
# tensor([[1, 2, 1, 2, 1, 2],
#         [3, 4, 3, 4, 3, 4],
#         [1, 2, 1, 2, 1, 2],
#         [3, 4, 3, 4, 3, 4]])
print(c)
# tensor([[[1, 2, 1, 2],
#          [3, 4, 3, 4]],
#         [[1, 2, 1, 2],
#          [3, 4, 3, 4]]])
print(e)
# tensor([[1, 1],
#         [2, 2],
#         [3, 3]])
e[0][1] = 213; print(e)
# tensor([[213, 213],
#         [2, 2],
#         [3, 3]])
```
