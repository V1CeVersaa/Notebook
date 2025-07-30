# Tensors and Their Operations

## Shape Operations

### `squeeze` & `unsqueeze`

- `#!py torch.squeeze(input: Tensor, dim: Optional[int, List[int]] = None) -> Tensor`
- `#!py torch.unsqueeze(input: Tensor, dim: int) -> Tensor`

`torch.squeeze` 移除张量形状中为 1 的维度/Singleton Dimensions，比如将形状为 `(1, 3, 1, 5)` 的张量变为 `(3, 5)`。添加参数 `torch.squeeze(dim)` 可以指定移除特定参数。**但是，其返回的张量和输入的张量共享存储，因此改变其中一个的内容会改变另外一个的内容**。

### `
