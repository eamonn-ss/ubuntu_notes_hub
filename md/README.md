# Notes Index

Editable runbooks live under topic folders.

- Filenames: [ADR-0002](../.ai/decisions/ADR-0002-note-filename-convention.md)（内容驱动 kebab-case）
- Metadata: [ADR-0003](../.ai/decisions/ADR-0003-note-metadata-header.md)（每篇含 `环境` / `验证`）

Descriptions below are from each note's actual topic.

## docker

| File | Summary |
|---|---|
| [docker-install-ubuntu.md](docker/docker-install-ubuntu.md) | Ubuntu 上安装 Docker（官方脚本 / 手动） |
| [docker-commands-cheatsheet.md](docker/docker-commands-cheatsheet.md) | 镜像与容器常用命令速查 |
| [docker-build-vpn-proxy.md](docker/docker-build-vpn-proxy.md) | Docker 构建阶段走宿主机 VPN/代理 |
| [docker-commit-persist-libstdcxx.md](docker/docker-commit-persist-libstdcxx.md) | 容器内修复 libstdc++ 后 commit 成新镜像 |

## frame_transform

| File | Summary |
|---|---|
| [denavit-hartenberg-params.md](frame_transform/denavit-hartenberg-params.md) | DH 参数定义与变换矩阵 |
| [point-cloud-registration.md](frame_transform/point-cloud-registration.md) | 点云配准术语、本质与粗/精配准层次 |

## git

| File | Summary |
|---|---|
| [git-beginner-tutorial.md](git/git-beginner-tutorial.md) | Git 入门：安装、结构、常用命令 |
| [github-443-proxy-fix.md](git/github-443-proxy-fix.md) | GitHub 443 连接失败时配置 HTTP(S) 代理 |

## linux_system

| File | Summary |
|---|---|
| [ubuntu-fishros-cudnn-setup.md](linux_system/ubuntu-fishros-cudnn-setup.md) | fishros 一键环境与 cuDNN 安装流程 |
| [apt-change-mirror.md](linux_system/apt-change-mirror.md) | 更改 apt 下载源 |
| [nvidia-container-toolkit-install.md](linux_system/nvidia-container-toolkit-install.md) | 安装并配置 NVIDIA Container Toolkit |
| [upgrade-libstdcxx-gcc11.md](linux_system/upgrade-libstdcxx-gcc11.md) | 手动升级 GCC 11 / libstdc++ |
| [systemd-basics.md](linux_system/systemd-basics.md) | systemd 概念与常用服务命令 |
| [multi-ipv4-on-one-nic.md](linux_system/multi-ipv4-on-one-nic.md) | 同一网口添加多个 IPv4 |
| [proxy-pip-timeout.md](linux_system/proxy-pip-timeout.md) | 代理环境下 pip 超时排查 |
| [vscode-server-download-network-fail.md](linux_system/vscode-server-download-network-fail.md) | VS Code Server 下载阶段网络失败 |
| [todesk-remote-black-screen.md](linux_system/todesk-remote-black-screen.md) | ToDesk 等远程黑屏（无显示器 / X11） |
| [grub-recovery-boot-stuck.md](linux_system/grub-recovery-boot-stuck.md) | 系统卡住时进入 GRUB 恢复模式 |

## mujoco

| File | Summary |
|---|---|
| [mujoco-py-install.md](mujoco/mujoco-py-install.md) | MuJoCo 210 + mujoco-py 安装 |

## mvs

| File | Summary |
|---|---|
| [hikrobot-mvs-install-ubuntu.md](mvs/hikrobot-mvs-install-ubuntu.md) | Ubuntu 安装海康工业相机 MVS |

## others

| File | Summary |
|---|---|
| [onnx-opset-ir-basics.md](others/onnx-opset-ir-basics.md) | ONNX opset / IR 基础 |
| [python-project-layout.md](others/python-project-layout.md) | Python 项目结构与打包文件对比 |
| [frame-drop-queue-lag.md](others/frame-drop-queue-lag.md) | 队列缓存与丢帧（frame drop） |

## pico_unity

| File | Summary |
|---|---|
| [unity-hub-editor-install-linux.md](pico_unity/unity-hub-editor-install-linux.md) | Ubuntu/Linux 安装 Unity Hub 与 Editor |
| [pico-teleop-robot-setup.md](pico_unity/pico-teleop-robot-setup.md) | PICO 遥操机器人 Unity 项目搭建 |

## plc

| File | Summary |
|---|---|
| [snap7-plc-install.md](plc/snap7-plc-install.md) | Snap7 PLC 库安装与构建 |

## ros2

| File | Summary |
|---|---|
| [colcon-basics.md](ros2/colcon-basics.md) | colcon 概念与常用命令 |
| [ros2-package-and-commands.md](ros2/ros2-package-and-commands.md) | ROS 2 功能包与常用 CLI |
| [package-xml-guide.md](ros2/package-xml-guide.md) | package.xml 结构与依赖标签 |
| [ros2-distributed-comms.md](ros2/ros2-distributed-comms.md) | ROS 分布式通信架构要点 |

## ue_a2f

| File | Summary |
|---|---|
| [ace-unreal-a2f-metahuman-data-capture.md](ue_a2f/ace-unreal-a2f-metahuman-data-capture.md) | NVIDIA ACE Audio2Face-3D + MetaHuman 数据采集 |
| [facegood-metahuman-dataset-rebuild.md](ue_a2f/facegood-metahuman-dataset-rebuild.md) | FACEGOOD → UE MetaHuman 数据集环境重建 |

## yolo

| File | Summary |
|---|---|
| [ultralytics-yolo-env-setup.md](yolo/ultralytics-yolo-env-setup.md) | Ultralytics YOLO 环境配置 |

## Related (outside md/)

### pdf/

| File | Summary | Related notes |
|---|---|---|
| [git-reference.pdf](../pdf/git-reference.pdf) | Git 参考 PDF | [git-beginner-tutorial.md](git/git-beginner-tutorial.md) |
| [linux-cuda.pdf](../pdf/linux-cuda.pdf) | Linux CUDA 相关 | [ubuntu-fishros-cudnn-setup.md](linux_system/ubuntu-fishros-cudnn-setup.md) |
| [cuda-windows.pdf](../pdf/cuda-windows.pdf) | Windows CUDA 相关 | — |
| [linux-install-under-windows.pdf](../pdf/linux-install-under-windows.pdf) | Windows 下安装 Linux | — |
| [chrome-force-bookmarks-bar-policy.pdf](../pdf/chrome-force-bookmarks-bar-policy.pdf) | Chrome 强制书签栏策略 | — |

### shell/

| Path | Summary |
|---|---|
| [../shell/install-opencv.sh](../shell/install-opencv.sh) | OpenCV 源码安装脚本 |
| [../shell/fix-opencv-glibcxx-error.md](../shell/fix-opencv-glibcxx-error.md) | OpenCV import 时 GLIBCXX 版本不匹配 |
