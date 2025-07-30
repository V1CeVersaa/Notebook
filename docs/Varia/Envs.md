# Environment & Tools

早已经不使用 Windows 了，将原来的 Win 本传给爸妈也应该只是时间的问题，大概记录一些 MacOS 上的配置和纯 Linux 的配置，总体不与 Programming Utils 相重合。

## Mamba & Conda & uv

Anaconda 过于庞大，现在使用的是 micromamba，之后可能也会使用 miniconda 作为包管理器，最近也有尝试 uv。

我在我的 MacBook 上使用 uv 进行包管理，使用主要分为两个部分，分别基于 `uv tool` 进行工具管理以及使用 uv 进行项目管理。

### uv 工具管理

使用 `uvx` 调用工具而无需安装，`uvx` 完全等价于 `uv tool run`，当调用 `uvx sometool` 的时候，在 uv 缓存目录 `uv cache dir` 中产生一个一次性的虚拟环境，环境被缓存来降低重复调用开销，使用 `uv cache clean` 来清除所有缓存，之后再次调用会再创建一个环境。常见使用方法包括：

- 指定版本运行：`uvx ruff@0.3.0 check`，`uvx --from 'ruff>0.2.0,<0.3.0' ruff check`；
- 请求额外功能：`uvx --from 'mypy[faster-cache,reports]==1.13.0' mypy --xml-report mypy_report`；
- 请求特定来源：`uvx --from git+https://github.com/httpie/cli@master httpie`；
- 带插件使用：`uvx --with mkdocs-material mkdocs --help`；

相比而言，使用 `uv tool install` 会在 uv 工具目录 `uv tool dir` 的同名子目录下创建一个虚拟环境，装该工具提供的所有可执行文件，直到该工具被删除的时候才会将虚拟环境删除，手动删除环境会导致工具无法运行。安装后的工具可以直接运行，但是这个工具不会在其余环境中有效。常见使用方法包括：

- 指定版本安装：`uv tool install 'httpie>0.1.0'`；
- 指定软件包源：`uv tool install git+https://github.com/httpie/cli`；
- 安装额外插件：`uv tool install mkdocs --with mkdocs-material`，`uv tool install mkdocs --with-requirements requirements.txt`；

工具的安装不会覆盖之前未由 uv 安装的 bin 目录中的可执行文件。例如，如果使用 pipx 安装了某个工具， `uv tool install` 将会失败。可以使用 `--force` 标志来覆盖此行为。

除此之外，使用 `uv tool upgrade <tool>` 升级已经安装的工具的工具环境下的所有包，使用 `uv tool upgrade <tool> --upgrade-package <sub-package>` 升级工具环境中的单个软件包。工具升级将遵循安装工具时提供的版本约束，替换约束使用 `uv tool install` 重新安装进行整体替换。重新安装工具使用 `--reinstall` 选项，使用 `--reinstall-package <sub-package>` 重新安装指定包。

### uv 项目环境管理

基本使用只需要 `uv init/add/remove/sync/lock` 即可，简单有效。

## LLVM Tool Chain

## Cursor & VS Code

## ITerm2 & fish

## Command Line Tools

- tldr: `brew install tlrc`
