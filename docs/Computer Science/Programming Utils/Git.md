# Git

## 基本操作

!!! Info "下面会对一些不太常见，威力巨大，但是确实需要掌握的命令进行介绍"

## `git reset`

## `git revert`

## `git rebase`

## `git merge`

<!-- 在大型项目中，常用的 Git 命令按功能大致可分为以下几类：

---

### 一、配置与初始化

* `git config`
  设置用户信息及 Git 行为，例如 `git config --global user.name "你名字"`、`git config --global core.editor vim`。

* `git init`
  在当前目录初始化一个新的本地仓库。

* `git clone <url>`
  从远程仓库复制一份到本地，并自动设定 `origin` 远程源。

---

### 二、查看状态与历史

* `git status`
  查看当前工作区和暂存区状态，提示哪些文件被修改、哪些文件未跟踪等。

* `git log`
  查看提交历史；常用选项如 `--oneline`（单行摘要）、`--graph`（图形化分支结构）。

* `git diff`
  对比工作区与暂存区或不同提交之间的差异。

* `git show <commit>`
  显示某次提交的详细信息，包括差异。

* `git blame <file>`
  查看文件每行最后一次修改的提交者及提交 ID。

---

### 三、暂存与提交

* `git add <file>`
  将修改加入到暂存区，准备纳入下一次提交；`git add .` 一次性添加所有改动。

* `git commit -m "描述"`
  以暂存区内容创建一次新提交，并附带描述；也可用 `-a` 跳过手动 `add`：`git commit -am "描述"`。

* `git reset [--soft|--mixed|--hard] <commit>`
  回退到指定提交：

  * `--soft` 仅回退 HEAD，不改动暂存区／工作区；
  * `--mixed`（默认）回退 HEAD 并清空暂存区；
  * `--hard` 连同工作区一起回退，谨慎使用。

* `git revert <commit>`
  新增一次“反向”提交，用于撤销某次历史提交，且不会重写历史。

---

### 四、分支与合并

* `git branch [<name>]`
  列出所有本地分支；加 `<name>` 可创建新分支。

* `git checkout <branch|commit>`
  切换分支或检出某个历史提交（进入 “游离 HEAD” 状态）。

* `git checkout -b <new-branch>`
  创建并切换到新分支。

* `git merge <branch>`
  将指定分支合并到当前分支，可能触发冲突需手动解决。

* `git rebase <base>`
  将当前分支的提交移动到另一个基点之上，用于整理提交历史；合并冲突后用 `git rebase --continue`。

* `git branch -d <branch>`
  删除本地分支；若未合并，可用 `-D` 强制删除。

---

### 五、远程协作

* `git remote -v`
  查看已配置的远程仓库地址。

* `git remote add <name> <url>`
  添加一个新的远程仓库源。

* `git fetch [<remote>]`
  从远程抓取最新改动到本地，但不自动合并。

* `git pull [<remote> [<branch>]]`
  等同于 `git fetch` + `git merge`，将远程改动拉取并合并到当前分支。

* `git push [<remote> [<branch>]]`
  将本地分支的提交推送到远程；首次推送新分支需加上 `--set-upstream`。

* `git push --force`
  强制推送（慎用），会覆盖远程历史。

---

### 六、标签与发布

* `git tag`
  列出所有标签；`git tag <name>` 创建轻量标签；`git tag -a <name> -m "msg"` 创建附注标签。

* `git push <remote> --tags`
  推送所有本地标签到远程。

---

### 七、暂存区管理

* `git stash`
  将当前工作区未提交的修改“藏”起来，还原到干净状态。

* `git stash list`
  列出所有 stash 条目。

* `git stash apply [<stash>]`
  恢复指定或最新的 stash，但保留 stash 记录。

* `git stash drop <stash>`
  删除指定 stash。

---

### 八、历史修复与调试

* `git bisect start` → `git bisect bad`/`good`
  二分查找引入 bug 的提交。

* `git reflog`
  查看 HEAD 的移动历史，用于找回“丢失”分支或提交。

* `git cherry-pick <commit>`
  将指定提交的改动应用到当前分支。

* `git fsck`
  检查仓库完整性，找出损坏对象。

* `git gc`
  垃圾回收，清理并打包松散对象，优化仓库。

---

### 九、子模块与子树

* `git submodule add <repo> [<path>]`
  将另一个仓库作为子模块加入。

* `git submodule update --init --recursive`
  克隆或更新子模块及其嵌套子模块。

* `git subtree`
  （需额外安装）将子仓库合并到主仓库目录，简化子项目管理。

---

以上命令覆盖了从配置、日常开发、分支管理、协作到历史修复的大部分场景。在参与大型项目时，熟练掌握它们能帮助你高效、安全地与团队协作。
 -->

