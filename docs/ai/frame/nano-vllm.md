# Nano-vLLM 项目学习指南

## 目录

- [项目简介](#项目简介)
- [项目结构总览](#项目结构总览)
- [前置知识](#前置知识)
- [推荐学习路线](#推荐学习路线)
- [第一阶段：公共接口层](#第一阶段公共接口层)
- [第二阶段：引擎核心 — 调度与序列管理](#第二阶段引擎核心--调度与序列管理)
- [第三阶段：KV Cache 与 Block 管理](#第三阶段kv-cache-与-block-管理)
- [第四阶段：模型执行器 ModelRunner](#第四阶段模型执行器-modelrunner)
- [第五阶段：模型架构与自定义算子](#第五阶段模型架构与自定义算子)
- [核心数据流](#核心数据流)
- [关键优化技术详解](#关键优化技术详解)
- [动手实验建议](#动手实验建议)

---

## 项目简介

Nano-vLLM 是一个从零实现的轻量级 vLLM（高吞吐 LLM 推理引擎），总代码量约 1200 行 Python。它在保持可读性的同时，实现了与 vLLM 相当的推理速度。

核心特性：
- **Prefix Caching**：前缀缓存，复用相同前缀的 KV Cache
- **CUDA Graph**：预录制 GPU 执行图，消除 kernel launch 开销
- **Tensor Parallelism**：多 GPU 张量并行
- **Torch Compilation**：对关键算子进行 JIT 编译
- **Flash Attention**：高效的注意力计算

---

## 项目结构总览

```
nano-vllm/
├── nanovllm/
│   ├── __init__.py              # 公共 API 导出（LLM, SamplingParams）
│   ├── llm.py                   # LLM 类（用户接口，继承 LLMEngine）
│   ├── config.py                # 配置数据类
│   ├── sampling_params.py       # 采样参数（temperature, max_tokens 等）
│   ├── engine/                  # 推理引擎核心
│   │   ├── llm_engine.py        # LLMEngine — 核心调度循环
│   │   ├── scheduler.py         # 请求调度器（prefill/decode 两阶段）
│   │   ├── sequence.py          # 序列/请求状态追踪
│   │   ├── model_runner.py      # 模型执行器（GPU 计算、CUDA Graph）
│   │   └── block_manager.py     # KV Cache Block 分配与前缀缓存
│   ├── models/
│   │   └── qwen3.py             # Qwen3 模型实现
│   ├── layers/                  # 自定义层实现
│   │   ├── attention.py         # Flash Attention + KV Cache 存储（含 Triton kernel）
│   │   ├── linear.py            # 张量并行线性层
│   │   ├── layernorm.py         # RMSNorm（融合残差加法）
│   │   ├── rotary_embedding.py  # 旋转位置编码（RoPE）
│   │   ├── sampler.py           # Token 采样器
│   │   ├── embed_head.py        # 词汇表并行的 Embedding 和 LM Head
│   │   └── activation.py        # SiLU 激活 + Gate 乘法
│   └── utils/
│       ├── context.py           # 全局执行上下文（线程局部变量）
│       └── loader.py            # 模型权重加载（safetensors）
├── example.py                   # 使用示例
└── bench.py                     # 性能基准测试
```

---

## 前置知识

在阅读代码之前，建议对以下概念有基本了解：

| 领域            | 内容                                                        | 重要程度 |
| --------------- | ----------------------------------------------------------- | -------- |
| Transformer     | Decoder-only 架构、Self-Attention、KV Cache                 | 必需     |
| PyTorch         | `nn.Module`、`torch.inference_mode`、CUDA 基础              | 必需     |
| LLM 推理        | Prefill 与 Decode 两阶段、自回归生成                        | 必需     |
| Flash Attention | `flash_attn_varlen_func` / `flash_attn_with_kvcache` 的作用 | 推荐     |
| CUDA Graph      | 什么是 CUDA Graph，为什么能加速                             | 推荐     |
| Triton          | Triton JIT kernel 基础语法                                  | 了解即可 |
| 分布式          | `torch.distributed`、NCCL、Tensor Parallelism               | 了解即可 |

---

## 推荐学习路线

按照**自顶向下**的顺序阅读，先理解宏观调度逻辑，再深入底层实现：

```
用户接口 → 引擎调度循环 → 调度器 → 序列管理 → Block 管理
    → 模型执行器 → 模型架构 → 自定义算子层
```

---

## 第一阶段：公共接口层

### 文件：`nanovllm/llm.py` + `nanovllm/sampling_params.py` + `nanovllm/config.py`

**目标**：理解用户如何使用这个系统。

```python
from nanovllm import LLM, SamplingParams

llm = LLM("/path/to/Qwen3-0.6B", enforce_eager=True, tensor_parallel_size=1)
outputs = llm.generate(prompts, SamplingParams(temperature=0.6, max_tokens=256))
```

**关键点**：
- `LLM` 继承自 `LLMEngine`，是一个薄封装
- `SamplingParams` 控制生成行为（温度、最大 token 数、是否忽略 EOS）
- `Config` 集中管理系统配置，包含：
  - `max_num_batched_tokens=16384`：单次 prefill 最大 token 数
  - `max_num_seqs=512`：最大并发序列数
  - `kvcache_block_size=256`：KV Cache block 大小
  - `gpu_memory_utilization=0.9`：GPU 显存利用率

---

## 第二阶段：引擎核心 — 调度与序列管理

### 文件：`nanovllm/engine/llm_engine.py`

**这是整个系统的心脏**。`LLMEngine` 协调三大组件：Tokenizer、Scheduler、ModelRunner。

#### 初始化流程

```python
def __init__(self, model, **kwargs):
    config = Config(model, **config_kwargs)
    # 1. 启动 tensor parallel worker 进程（rank > 0）
    for i in range(1, config.tensor_parallel_size):
        process = ctx.Process(target=ModelRunner, args=(config, i, event))
        process.start()
    # 2. 创建主进程 ModelRunner（rank 0）
    self.model_runner = ModelRunner(config, 0, self.events)
    # 3. 加载 tokenizer
    self.tokenizer = AutoTokenizer.from_pretrained(config.model)
    # 4. 创建调度器
    self.scheduler = Scheduler(config)
```

#### 核心循环：`step()` 方法

```python
def step(self):
    seqs, is_prefill = self.scheduler.schedule()    # 1. 调度：决定哪些序列参与本轮计算
    token_ids = self.model_runner.call("run", seqs, is_prefill)  # 2. 执行：GPU 推理
    self.scheduler.postprocess(seqs, token_ids)     # 3. 后处理：追加 token、判断结束
```

这三步不断循环，直到所有序列生成完毕。

#### `generate()` 方法

```python
def generate(self, prompts, sampling_params):
    for prompt, sp in zip(prompts, sampling_params):
        self.add_request(prompt, sp)       # 将所有 prompt 加入等待队列
    while not self.is_finished():
        output, num_tokens = self.step()   # 反复执行 step
    return outputs                          # 返回解码后的文本
```

### 文件：`nanovllm/engine/sequence.py`

`Sequence` 表示一个生成请求的完整状态：

```python
class Sequence:
    seq_id: int                    # 唯一标识
    status: SequenceStatus         # WAITING → RUNNING → FINISHED
    token_ids: list[int]           # prompt tokens + 已生成 tokens
    block_table: list[int]         # 分配的 KV Cache block ID 列表
    num_cached_tokens: int         # 前缀缓存命中的 token 数
    temperature: float             # 采样温度
    max_tokens: int                # 最大生成长度
```

**值得注意的设计**：
- `__getstate__` / `__setstate__` 自定义 pickle 序列化——在 decode 阶段只传输 `last_token` 而非整个 token 列表，减少多进程通信开销
- `block()` 方法按 block_size 切分 token 序列，与 BlockManager 配合

### 文件：`nanovllm/engine/scheduler.py`

调度器管理两个队列和两个阶段：

```
waiting 队列 ──(prefill)──→ running 队列 ──(decode)──→ 循环生成
                                    ↑                       │
                                    └──(preempt 抢占)───────┘
```

#### Prefill 阶段（有等待中的请求时触发）

```python
while self.waiting and num_seqs < self.max_num_seqs:
    seq = self.waiting[0]
    # 检查 batched token 上限和 block 是否够分配
    if num_batched_tokens + len(seq) > self.max_num_batched_tokens \
       or not self.block_manager.can_allocate(seq):
        break
    self.block_manager.allocate(seq)         # 分配 KV Cache blocks
    seq.status = SequenceStatus.RUNNING
    self.running.append(seq)
```

#### Decode 阶段（无等待请求时）

```python
while self.running and num_seqs < self.max_num_seqs:
    seq = self.running.popleft()
    while not self.block_manager.can_append(seq):
        # 显存不足 → 抢占最后加入的序列，释放其 blocks
        self.preempt(self.running.pop())
    self.block_manager.may_append(seq)
```

#### 后处理

```python
def postprocess(self, seqs, token_ids):
    for seq, token_id in zip(seqs, token_ids):
        seq.append_token(token_id)
        if token_id == self.eos or seq.num_completion_tokens == seq.max_tokens:
            seq.status = SequenceStatus.FINISHED
            self.block_manager.deallocate(seq)
            self.running.remove(seq)
```

---

## 第三阶段：KV Cache 与 Block 管理

### 文件：`nanovllm/engine/block_manager.py`

这是 Prefix Caching 的核心实现。KV Cache 被分为固定大小的 block（默认 256 tokens/block）。

#### 核心思想

将 token 序列按 block_size 切分，对每个 block 的 token 内容计算 hash（使用 xxHash）。如果两个序列有相同的前缀 tokens，它们对应的 blocks 就有相同的 hash，可以**共享 KV Cache**。

#### Block 结构

```python
class Block:
    block_id: int          # 在 KV Cache 大张量中的索引
    ref_count: int         # 引用计数（多个序列共享同一 block）
    hash: int              # 该 block 内容的 xxHash
    token_ids: list[int]   # block 包含的 token IDs（用于验证 hash 碰撞）
```

#### 分配流程 `allocate(seq)`

```python
for i in range(seq.num_blocks):
    token_ids = seq.block(i)                     # 取第 i 个 block 的 tokens
    h = compute_hash(token_ids, prev_hash)       # 链式 hash
    block_id = hash_to_block_id.get(h, -1)       # 查缓存
    if block_id != -1 and blocks[block_id].token_ids == token_ids:
        # Cache 命中！复用已有 block
        seq.num_cached_tokens += block_size
        blocks[block_id].ref_count += 1
    else:
        # Cache 未命中，分配新 block
        block_id = free_block_ids[0]
        _allocate_block(block_id)
```

#### Decode 时的 Block 追加 `may_append(seq)`

```python
if len(seq) % block_size == 1:
    # 刚好需要一个新 block（上一个 block 已满）
    _allocate_block(new_block_id)
    block_table.append(new_block_id)
elif len(seq) % block_size == 0:
    # 当前 block 刚好填满，计算并保存 hash（供后续序列缓存命中）
    last_block.update(hash, token_ids)
```

---

## 第四阶段：模型执行器 ModelRunner

### 文件：`nanovllm/engine/model_runner.py`

ModelRunner 负责所有 GPU 端的操作。

#### 初始化顺序

```
1. 初始化分布式进程组（NCCL）
2. 创建模型并加载权重
3. Warmup（热身推理，触发 PyTorch 编译）
4. 分配 KV Cache（根据剩余 GPU 显存计算 block 数量）
5. 捕获 CUDA Graph（可选）
6. 多 GPU 下：rank 0 创建共享内存，rank > 0 进入 loop() 等待指令
```

#### KV Cache 分配

```python
def allocate_kv_cache(self):
    # 计算每个 block 的显存占用
    block_bytes = 2 * num_layers * block_size * num_kv_heads * head_dim * dtype_size
    # 根据 GPU 可用显存计算 block 数量
    num_blocks = available_memory // block_bytes
    # 分配一个大张量：[2, num_layers, num_blocks, block_size, num_kv_heads, head_dim]
    #                  ↑K和V
    self.kv_cache = torch.empty(2, num_layers, num_blocks, block_size, num_kv_heads, head_dim)
```

#### Prefill 数据准备 `prepare_prefill()`

为 `flash_attn_varlen_func` 准备输入：
- `input_ids`：跳过已缓存的 tokens（prefix caching 优化）
- `positions`：位置编码索引
- `cu_seqlens_q/k`：每个序列在 batch 中的累积长度（q 可能短于 k，因为前缀被缓存）
- `slot_mapping`：每个新 token 在 KV Cache 大张量中的存储位置

#### Decode 数据准备 `prepare_decode()`

每个序列只处理 1 个 token：
- `input_ids`：每个序列的最后一个 token
- `positions`：当前位置
- `context_lens`：每个序列的总长度（用于 attention mask）
- `block_tables`：每个序列的 block 映射表（用于从 KV Cache 读取历史 KV）

#### CUDA Graph 捕获

```python
def capture_cudagraph(self):
    # 为常见 batch size 预录制 CUDA Graph
    for bs in [1, 2, 4, 8, 16, 32, ...]:
        graph = torch.cuda.CUDAGraph()
        with torch.cuda.graph(graph):
            outputs[:bs] = self.model(input_ids[:bs], positions[:bs])
        self.graphs[bs] = graph
```

运行时通过 `graph.replay()` 回放，避免每次推理都重新 launch kernel。

#### Tensor Parallelism 通信

```python
# Rank 0（主进程）：通过共享内存发送指令
def write_shm(self, method_name, *args):
    data = pickle.dumps([method_name, *args])
    self.shm.buf[:] = data
    for event in self.events:
        event.set()     # 通知所有 worker

# Rank > 0（worker 进程）：等待并执行
def loop(self):
    while True:
        method_name, args = self.read_shm()  # 阻塞等待 event
        self.call(method_name, *args)
```

---

## 第五阶段：模型架构与自定义算子

### 文件：`nanovllm/models/qwen3.py`

标准的 Decoder-only Transformer 结构：

```
Input IDs
    │
    ▼
VocabParallelEmbedding          # 词嵌入
    │
    ▼
┌─────────────────────────┐
│  Qwen3DecoderLayer × N  │     # N 层 Decoder
│  ├── RMSNorm (+ residual)│
│  ├── Self-Attention       │
│  │   ├── QKV Projection  │
│  │   ├── RoPE            │
│  │   ├── Flash Attention  │
│  │   └── Output Proj     │
│  ├── RMSNorm (+ residual)│
│  └── MLP                 │
│      ├── Gate+Up Proj    │
│      ├── SiLU * Gate     │
│      └── Down Proj       │
└─────────────────────────┘
    │
    ▼
RMSNorm
    │
    ▼
ParallelLMHead                  # 输出 logits
```

**权重打包映射**（`packed_modules_mapping`）：
```python
# HuggingFace 原始权重 → Nano-vLLM 合并权重
"q_proj" → ("qkv_proj", "q")    # Q、K、V 合并为一次矩阵乘
"k_proj" → ("qkv_proj", "k")
"v_proj" → ("qkv_proj", "v")
"gate_proj" → ("gate_up_proj", 0)  # Gate 和 Up 合并
"up_proj"   → ("gate_up_proj", 1)
```

### 文件：`nanovllm/layers/attention.py`

包含两个关键部分：

**1. Triton Kernel — `store_kvcache_kernel`**

将当前层计算出的 K、V 写入 KV Cache 的对应 slot：

```python
@triton.jit
def store_kvcache_kernel(key_ptr, value_ptr, k_cache_ptr, v_cache_ptr, slot_mapping_ptr, D):
    idx = tl.program_id(0)
    slot = tl.load(slot_mapping_ptr + idx)   # 从 slot_mapping 查找存储位置
    # 将 key[idx] 写入 k_cache[slot]
    # 将 value[idx] 写入 v_cache[slot]
```

**2. Attention 前向传播**

```python
def forward(self, q, k, v):
    # 1. 将新的 K、V 写入 KV Cache
    store_kvcache(k, v, self.k_cache, self.v_cache, context.slot_mapping)

    if context.is_prefill:
        # 2a. Prefill：使用 flash_attn_varlen_func（支持变长序列）
        o = flash_attn_varlen_func(q, k, v, ...)
    else:
        # 2b. Decode：使用 flash_attn_with_kvcache（从 cache 读取历史 KV）
        o = flash_attn_with_kvcache(q, self.k_cache, self.v_cache, ...)
```

### 其他层

| 文件                         | 功能                                                     |
| ---------------------------- | -------------------------------------------------------- |
| `layers/linear.py`           | 张量并行线性层（QKVParallelLinear 等），按 head 维度切分 |
| `layers/layernorm.py`        | RMSNorm，融合了残差加法以减少 kernel launch              |
| `layers/rotary_embedding.py` | RoPE 旋转位置编码                                        |
| `layers/sampler.py`          | 温度缩放 + 随机采样                                      |
| `layers/embed_head.py`       | 词汇表并行的 Embedding 和 LM Head                        |
| `layers/activation.py`       | SiLU 激活与 Gate 的逐元素乘法                            |

---

## 核心数据流

完整的一次推理流程：

```
用户调用 llm.generate(prompts, sampling_params)
    │
    ▼
LLMEngine.add_request()
    │  Tokenizer 将文本 → token IDs
    │  创建 Sequence 对象，加入 Scheduler.waiting 队列
    ▼
┌──────────── 主循环 ────────────┐
│                                │
│  Scheduler.schedule()          │
│    ├─ 有 waiting → Prefill     │
│    │   分配 blocks，批量处理   │
│    └─ 无 waiting → Decode      │
│        逐 token 生成，必要时抢占│
│            │                   │
│            ▼                   │
│  ModelRunner.run()             │
│    ├─ prepare_prefill/decode() │
│    │   准备 input_ids, positions│
│    │   slot_mapping 等         │
│    ├─ run_model()              │
│    │   ├─ prefill: 直接推理    │
│    │   └─ decode: CUDA Graph   │
│    └─ sampler()                │
│        温度采样 → next token   │
│            │                   │
│            ▼                   │
│  Scheduler.postprocess()       │
│    ├─ 追加 token 到序列        │
│    ├─ 检查 EOS / max_tokens    │
│    └─ 完成的序列释放 blocks    │
│                                │
└──── 循环直到所有序列完成 ──────┘
    │
    ▼
Tokenizer 解码 token IDs → 文本
返回结果给用户
```

---

## 关键优化技术详解

### 1. Prefix Caching（前缀缓存）

**问题**：多个 prompt 可能共享相同的系统提示（system prompt），重复计算浪费时间。

**解法**：将 token 序列按固定大小分块，对每个块内容计算 hash。相同 hash 的块复用同一份 KV Cache，跳过重复计算。

**体现在代码中**：
- `BlockManager.allocate()` 中检查 hash 是否命中
- `ModelRunner.prepare_prefill()` 中跳过 `num_cached_tokens` 个 token

### 2. CUDA Graph（GPU 执行图）

**问题**：Decode 阶段每次只处理 1 个 token/序列，GPU kernel launch 的 CPU 开销占比很高。

**解法**：预先录制一系列 kernel 调用为 CUDA Graph，推理时只需 `graph.replay()` 一次性回放。

**体现在代码中**：
- `ModelRunner.capture_cudagraph()` 为 batch size = 1, 2, 4, 8, 16, ... 各录制一个 graph
- `ModelRunner.run_model()` 在 decode 时选择匹配的 graph 回放

### 3. Tensor Parallelism（张量并行）

**问题**：大模型无法放入单张 GPU。

**解法**：将注意力头和 MLP 的中间维度沿不同 GPU 切分。

**体现在代码中**：
- `QKVParallelLinear`：每个 GPU 处理 `num_heads / tp_size` 个头
- `RowParallelLinear`：输出后执行 `all_reduce` 聚合
- Rank 0 通过共享内存协调所有 worker

### 4. 算子融合

- **RMSNorm + 残差加法**：`layernorm.py` 中一步完成 norm 和残差相加
- **QKV 合并投影**：`q_proj`, `k_proj`, `v_proj` 合并为一次矩阵乘
- **Gate + Up 合并投影**：`gate_proj`, `up_proj` 合并为一次矩阵乘
- **SiLU + Gate 乘法**：`activation.py` 中融合

---

## 动手实验建议

### 实验 1：运行示例代码

```bash
# 下载模型
huggingface-cli download Qwen/Qwen3-0.6B --local-dir ~/huggingface/Qwen3-0.6B/

# 运行示例
python example.py
```

### 实验 2：添加调试日志

在 `scheduler.py` 的 `schedule()` 方法中加 print，观察 prefill/decode 的调度行为：

```python
def schedule(self):
    # 在 prefill 和 decode 分支各加一行：
    print(f"[Scheduler] prefill: {len(scheduled_seqs)} seqs, waiting: {len(self.waiting)}")
    print(f"[Scheduler] decode: {len(scheduled_seqs)} seqs, running: {len(self.running)}")
```

### 实验 3：理解 Block 分配

在 `block_manager.py` 的 `allocate()` 方法中打印缓存命中情况：

```python
if not cache_miss:
    print(f"[BlockManager] Cache HIT: block {block_id}, cached {seq.num_cached_tokens} tokens")
else:
    print(f"[BlockManager] Cache MISS: allocating new block {block_id}")
```

### 实验 4：关闭优化逐一对比

```python
# 关闭 CUDA Graph（强制 eager 模式）
llm = LLM(path, enforce_eager=True)

# 对比开启 CUDA Graph
llm = LLM(path, enforce_eager=False)
```

用 `bench.py` 对比两种模式的吞吐量差异。

### 实验 5：阅读顺序 checklist

按以下顺序逐文件阅读，每读完一个文件在前面打勾：

- [ ] `sampling_params.py`（最简单，3 个字段）
- [ ] `config.py`（理解所有配置项）
- [ ] `engine/sequence.py`（序列状态机）
- [ ] `engine/block_manager.py`（prefix caching 实现）
- [ ] `engine/scheduler.py`（两阶段调度）
- [ ] `engine/llm_engine.py`（核心循环）
- [ ] `engine/model_runner.py`（GPU 执行，最复杂）
- [ ] `utils/context.py`（全局上下文传递）
- [ ] `utils/loader.py`（权重加载和打包映射）
- [ ] `layers/attention.py`（Triton kernel + Flash Attention）
- [ ] `layers/linear.py`（张量并行）
- [ ] `models/qwen3.py`（模型架构）
- [ ] `layers/` 其余文件（辅助层）

---

> **提示**：这个项目只有约 1200 行代码，是学习 LLM 推理引擎内部实现的绝佳材料。建议配合 vLLM 原版文档对照阅读，理解每个简化背后的设计取舍。
