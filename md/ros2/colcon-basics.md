# colcon

## colcon 是什么？

1. colcon 是 ROS 2 官方推荐的 工作空间构建与任务管理工具。它的全称是 “COllective CONstruction”，意思是“集体构建”。它会自动识别、按依赖顺序构建 src/ 下所有包。

## 为什么会有 colcon？

1. ROS 2 时代，系统支持了 多种构建系统：ament_cmake, ament_python, pure cmake, setuptools（Python 原生包）, 于是需要一个通用工具来统一管理这些不同类型的包。

## colcon 的主要功能

| 功能                 | 说明                            |
| ------------------ | ----------------------------- |
| 🏗️ **构建（build）**  | 编译整个工作空间中的所有包                 |
| 🧩 **依赖解析**        | 自动根据 `package.xml` 的依赖顺序构建    |
| 🔗 **安装（install）** | 把编译结果安装到 `install/` 目录（或符号链接） |
| 🚀 **测试（test）**    | 运行包内的测试（`pytest`、`gtest` 等）   |
| 📦 **打包（bundle）**  | 创建可分发的安装包                     |
| 🔍 **日志管理（log）**   | 查看编译与运行时日志                    |

## 常用命令

| 命令                                      | 功能           | 示例                                             |
| --------------------------------------- | ------------ | ---------------------------------------------- |
| `colcon build`                          | 构建工作空间       | `colcon build --symlink-install`               |
| `colcon test`                           | 运行测试         | `colcon test --event-handlers console_direct+` |
| `colcon test-result`                    | 查看测试结果       | `colcon test-result --verbose`                 |
| `colcon list`                           | 列出当前工作空间中的包  | `colcon list`                                  |
| `colcon clean`                          | 清理构建、安装、日志目录 | `colcon clean`                                 |
| `colcon build --packages-select my_pkg` | 构建指定包        | `colcon build --packages-select my_robot`      |

## colcon 构建的目录结构
    ```te
    ros2_ws/
    ├── src/         ← 源代码
    ├── build/       ← 编译中间文件
    ├── install/     ← 可运行文件（可执行文件、库、脚本）
    └── log/         ← 编译日志与错误信息
    ```

    colcon 会：

    扫描 src/ 下所有包；

    按依赖顺序构建；

    把可执行文件、资源、脚本链接到 install/；

    在 build/ 中保存编译缓存；

    在 log/ 中保存输出日志。


| 目录         | 作用              | 典型内容                              | 是否可删除          |
| ---------- | --------------- | --------------------------------- | -------------- |
| `build/`   | 编译的中间产物         | `.o`, `CMakeFiles`, `build.ninja` | ✅ 可删除（重建时自动生成） |
| `install/` | 最终安装产物（运行节点时使用） | 可执行文件、库、launch、头文件                | ✅ 可删除（需重新编译）   |
| `log/`     | 构建/测试日志记录       | stdout/stderr 日志、事件记录             | ✅ 可删除（不影响程序）   |

install/ 目录下看到的内容

| 文件名                                 | 作用                     | 主要用于                      |
| ----------------------------------- | ---------------------- | ------------------------- |
| `setup.bash`                        | 全局环境设置（bash版本）         | Linux bash 用户最常用          |
| `setup.zsh`                         | 全局环境设置（zsh版本）          | zsh 用户（例如 macOS 默认 shell） |
| `setup.ps1`                         | PowerShell 环境设置        | Windows PowerShell 用户     |
| `setup.sh`                          | 通用 shell 设置脚本          | 用于其他类型 shell（例如 dash）     |
| `local_setup.bash / zsh / ps1 / sh` | 局部环境设置脚本               | 为当前 workspace 层配置路径       |
| `_local_setup_util_sh.py / ps1.py`  | Python 工具脚本            | 上述脚本的底层实现逻辑               |
| `COLCON_IGNORE`                     | 标记文件，告诉 colcon 不要构建该目录 | 避免重复构建                    |
| `my_package/`                       | 你自己的包安装目录              | 包含编译好的可执行文件、头文件等          |

当你执行：`source install/setup.bash`


系统会按以下层次加载环境变量：

- 调用 setup.bash
- 自动调用 local_setup.bash
- 调用 _local_setup_util_sh.py（Python 实现）

最终修改的内容包括：

- 更新环境变量 AMENT_PREFIX_PATH（查找包安装路径）

- 更新 PYTHONPATH（让 Python 能找到 ROS 包）

- 更新 PATH（让可执行文件能直接运行）

- 更新 LD_LIBRARY_PATH（动态链接库路径）

- 设置 COLCON_PREFIX_PATH（记录 workspace 链接顺序）

这样，你之后就可以运行：`ros2 run my_package my_node` 因为 ROS 2 已经知道从哪里加载包了。


## 常用参数（build 阶段）

| 参数                                 | 说明                                            |
| ---------------------------------- | --------------------------------------------- |
| `--symlink-install`                | 使用符号链接代替文件复制（开发时常用）                           |
| `--packages-select <pkg>`          | 只编译指定包                                        |
| `--packages-skip <pkg>`            | 跳过指定包                                         |
| `--event-handlers console_direct+` | 直接在终端显示构建进度                                   |
| `--parallel-workers N`             | 指定并行线程数                                       |
| `--cmake-args`                     | 传递额外的 CMake 参数，如：`-DCMAKE_BUILD_TYPE=Release` |

## 与 ament 的关系

| 工具                             | 层级    | 作用              |
| ------------------------------ | ----- | --------------- |
| **ament_cmake / ament_python** | 构建系统  | 定义“怎么编译一个包”     |
| **colcon**                     | 构建调度器 | 负责“编译哪些包、以什么顺序” |

ament 负责单个包的构建，colcon 负责整个工作空间的组织。