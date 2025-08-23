# Screen & tmux
 
!!! Info

    tmux 和 Screen 都是终端复用工具，可以方便地管理多个终端窗口。在训练模型的时候，使用 Screen 和 tmux 可以使得训练任务在后台运行，不因为终端关闭而中断。我用 Screen 比较多。

## Screen

快捷键前缀：`Ctrl+a`

### 分离与链接

- `Ctrl+a d`：分离当前会话，分离之后会话中运行的程序会继续运行；
- `screen -ls` 或 `screen -list`：列出所有会话，格式为 `pid.tty.host`，或者 `pid.sessionname`；
- `screen -r nu`：重新链接 pid 为 `nu` 的会话；
- `screen -R`：重新链接分离的会话，但要求至多有一个会话，如果没有会话，则创建一个会话；
- `screen -S sessionname`：创建一个名为 `sessionname` 的会话。

### 窗口管理

- `Ctrl+a c`：创建新的窗口，系统分配 0 到 9 的最小可用数字作为编号；
- `Ctrl+a "`：列出所有窗口；
- `Ctrl+a nu`：切换到编号为 `nu` 的窗口；
- `Ctrl+a A`：重命名当前窗口；

### 输入区域管理

- `Ctrl+a Ctrl+a`：在当前窗口和上一个窗口之间切换；
- `Ctrl+a S`：当当前区域分割为水平两个区域；
- `Ctrl+a |`：当当前区域分割为垂直两个区域；
- `Ctrl+a tab`：将输入焦点切换到下一个区域；
- `Ctrl+a Q`：关闭除了当前区域之外的所有区域；
- `Ctrl+a X`：关闭当前区域；

## tmux

快捷键前缀：`Ctrl+b`

- `Ctrl+b d`：分离当前会话；
- `tmux attach`：重新链接分离的会话；
- `tmux ls`：列出所有会话；
- `Ctrl+b s`：列出所有会话；
- `Ctrl+b $`：重命名当前会话；

### 会话管理

- `Ctrl+b number`：切换窗口；
- `Ctrl+b c`：创建新窗口，系统分配 0 到 9 的最小可用数字作为编号；

### 窗格管理

- `Ctrl+b %`：划分左右两个窗格；
- `Ctrl+b "`：划分上下两个窗格；
- `Ctrl+b <arrow key>`：光标以当前窗格按照方向键方向切换窗格；
- `Ctrl+b ;`：切换到上一个窗格；
- `Ctrl+b o`：切换到下一个窗格；
- `Ctrl+b x`：关闭当前窗格；
- `Ctrl+b !`：将当前窗格拆分为独立窗口；
- `Ctrl+b z`：当前窗格全屏显示，再按一次会恢复；
