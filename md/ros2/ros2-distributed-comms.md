# ros分布式通信

> 环境：ROS 1/2 分布式通信
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[ros2-package-and-commands.md](ros2-package-and-commands.md)


## 分布式通信架构

- 两台设备之间可以使用 ROS（包括 ROS1 和 ROS2）进行话题的接收与发送通信。这是 ROS 的一个核心功能 —— 分布式通信架构

- 前提条件

    1. 两台设备在同一局域网内。确保它们：连接到同一个 Wi-Fi 或有线网络；可以通过 ping 命令互相访问。
    2. 配置环境变量：ROS_DOMAIN_ID 或 ROS_NAMESPACE（可选），ROS2 默认使用 DDS（Data Distribution Service），所以网络发现依赖 multicast。通常不需要手动配置主机地址，只需设置：`export ROS_DOMAIN_ID=0  # 两台设备设置为一样的值即可`
    3. 关闭防火墙（或开放必要端口）。Ubuntu 系统默认可能开启 ufw，你可以：`sudo ufw disable`，或者开放特定端口组。
    4. eg：

        设备 A（发送话题）:`ros2 topic pub /chatter std_msgs/String "data: Hello from A" `

        设备 B（接收话题）:`ros2 topic echo /chatter`
    5. 设置 Fast DDS 中的 ROS_LOCALHOST_ONLY

        如果你发现只能本地通信而不能跨设备，请确保未设置以下环境变量：`unset ROS_LOCALHOST_ONLY`
    6. 网络测试方法：

        确保能相互 ping`ping <对方的IP>`

        使用 ros2 topic list 查看是否能收到远程话题。

- 检查指令

    | 检查点                                 | 命令                         | 要求                   |
    | ----------------------------------- | -------------------------- | -------------------- |
    | IP 通不通？                             | `ping 192.168.31.179`      | ✅ 已成功                |
    | 环境变量                                | `echo $ROS_DOMAIN_ID`      | 两台一样，例如 `0`          |
    | 是否设置了 `ROS_LOCALHOST_ONLY`          | `echo $ROS_LOCALHOST_ONLY` | 若有输出 `1`，需 `unset` 掉 |
    | ROS2 启动环境是否加载                       | `echo $ROS_VERSION`        | 应输出 `2`              |
    | A 本地是否能 `ros2 topic echo /chatter`？ | ✅ 否则说明发布失败                 |                      |

    ROS_LOCALHOST_ONLY=1：强制 只使用回环地址通信（只能本机之间通信）

    ROS_LOCALHOST_ONLY=0：虽看似关闭，但依然是“被设置了”，Fast DDS 会识别这个变量为“显式配置”，仍可能导致通信异常

    正确做法是：完全取消这个变量的设置


- 检查脚本

    ```te
    echo "ROS_VERSION = $ROS_VERSION"
    echo "ROS_DISTRO  = $ROS_DISTRO"
    echo "ROS_DOMAIN_ID = $ROS_DOMAIN_ID"
    echo "ROS_LOCALHOST_ONLY = $ROS_LOCALHOST_ONLY"
    ```

- 解决方案

    ① 先加载 ROS2 环境（推荐放第一步）

    `source /opt/ros/<你的版本>/setup.bash`  # 例如 foxy、humble 等

    ② 设置 ROS_DOMAIN_ID
    `export ROS_DOMAIN_ID=0`

    ③ 取消 localhost 限制
    `unset ROS_LOCALHOST_ONLY`

    把它们都加入 ~/.bashrc 里，每次开机自动设置，所有的测试程序需关闭重新进入测试
