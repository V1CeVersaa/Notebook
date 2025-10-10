# CS 285: Deep Reinforcement Learning

## Table of Contents

- [ ] [Supervised Learning, Deep Learning and Reinforcement Learning Intro](./Chapter%201.md)
- [ ] [Model-free Methods](./Chapter%202.md)
- [ ] [Model-based Methods](./Chapter%203.md)
- [ ] [Exploration](./Chapter%204.md)
- [ ] [Offline Reinforcement Learning](./Chapter%205.md)
- [ ] [Inverse Reinforcement Learning](./Chapter%206.md)
- [ ] [Advanced Topics](./Chapter%207.md)

## Introduction

### Forms of Supervision

- Learning from Demonstrations:
    - Directly copying observed behavior;
    - **Inferring rewards** form observed behavior/Inverse Reinforcement Learning.
- Learning from Observing the World:
    - Learning to Predict：预测接下来会发生什么，即使当前并不确定应该做什么，然后在对任务更加了解之后再利用这些知识；
    - Unsupervised Learning：使用无监督特征提取之类的操作。
- Learning form Other Tasks:
    - Imitation Learning;
    - Meta-Learning: Learning to Learn.

### Imitation Learning

[Nvidia 在 2016 年的一篇工作](https://arxiv.org/pdf/1604.07316) 实现了自动驾驶方面完全端到端的模仿学习，其方法试图完全复制观察到的人类驾驶行为。但是这个工作被认为是糟糕的，根据心理学来讲，在模仿方面，人类做的事情并不是简单的模仿肌肉的运动行为，而是进一步了解意图，推断其正在试图做什么，然后以自己的方式去做，这可能就会引起一些新的行为或者提升。 

### How de We Build Intelligent Machines

What Challenges still Remain?

- We have great methods that can learn from huge amounts of data;
- We have great optimization methods for RL;
- We **don't** have amazing methods that **both** use data and RL;
- Humans can learn incredibly **quickly**, deep RL methods are usually **slow**;
- Humans **reuse** past knowledge, transfer learning in RL is still an **open problem**;
- Not clear what the reward function should be;
- Not clear what the role of prediction should be.
