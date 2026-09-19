# 功能包

> 环境：ROS 2
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[colcon-basics.md](colcon-basics.md) · [package-xml-guide.md](package-xml-guide.md)


## 功能包（Package） 是构建系统的最小单元，通常包含实现某一功能的代码、配置和资源文件。

    功能包（package）就是 ROS 2 中用于封装某一功能模块的目录结构，它可以包含：

    节点（Node）代码（C++ / Python）

    启动文件（launch）

    消息定义（msg）/ 服务定义（srv）

    配置文件（.yaml、.rviz、.urdf）

    依赖声明（package.xml）

    构建配置（CMakeLists.txt / setup.py）

## 命令

- ros2 pkg 是一个用于操作 软件包（package） 的命令行工具，基本语法：`ros2 pkg <subcommand> [arguments]`

- 常用子命令

    | 子命令            | 功能说明            | 示例                                    |
    | -------------- | --------------- | ------------------------------------- |
    | `list`         | 列出所有已安装的 ROS2 包 | `ros2 pkg list`                       |
    | `prefix`       | 显示指定包的安装路径      | `ros2 pkg prefix rclcpp`              |
    | `executable`   | 获取某包中可执行文件名列表   | `ros2 pkg executables demo_nodes_cpp` |
    | `create`       | 创建一个新的 ROS2 包   | `ros2 pkg create my_pkg`              |
    | `dependencies` | 显示包的依赖项         | `ros2 pkg dependencies rclcpp`        |

- `ros2 pkg list`, 列出所有已安装的包

- `ros2 pkg prefix demo_nodes_cpp`,输出为`/opt/ros/humble`,这表示demo_nodes_cpp 功能包的安装路径是 /opt/ros/humble，也就是说，它的源码/可执行文件/配置资源都安装在这个 ROS 2 安装目录下。

- `ros2 pkg executables demo_nodes_cpp`,查看包内的可执行文件,输出：
    ```te
    demo_nodes_cpp talker
    demo_nodes_cpp listener
    ```

    可以直接运行:`ros2 run demo_nodes_cpp talker`

- `ros2 pkg create my_robot_pkg --build-type ament_cmake --dependencies rclcpp std_msgs`创建一个新的 ROS2 包。

    参数说明：

    --build-type：指定构建系统（如 ament_cmake 或 ament_python）

    --dependencies：指定依赖项包名

- `ros2 pkg dependencies turtlesim`,查看包的依赖项

- 功能包结构
    ```te
    my_robot_pkg/
    ├── CMakeLists.txt            # 构建配置
    ├── package.xml               # 依赖和元信息
    ├── launch/                   # 启动文件（可选）
    │   └── bringup.launch.py
    ├── config/                   # 配置参数（可选）
    │   └── robot.yaml
    ├── msg/                      # 自定义消息类型（可选）
    │   └── MyMsg.msg
    ├── srv/                      # 自定义服务类型（可选）
    │   └── MyService.srv
    ├── urdf/                     # 机器人模型（可选）
    │   └── robot.urdf
    ├── rviz/                     # RViz 配置（可选）
    │   └── robot.rviz
    ├── src/                      # 节点源代码
    │   └── talker.cpp
    ```

## urdf

- URDF（Unified Robot Description Format）是一种用 XML 表达的格式，用来描述机器人模型。它主要用于 ROS 中描述机器人的几何形状、关节结构、惯性信息和传感器等。

- 基本结构

    ```te
    <robot name="my_robot">
    <!-- 链接定义 -->
    <link name="base_link">
        ...
    </link>

    <!-- 关节定义 -->
    <joint name="joint1" type="revolute">
        ...
    </joint>
    </robot>
    ```

- 常用指令

| 类别           | XML标签/语法                                                       | 功能说明                          |
| ------------ | -------------------------------------------------------------- | ----------------------------- |
| **基础结构**     | `<robot name="...">`                                           | 机器人模型的根元素，必须以此开始              |
|              | `<link name="...">`                                            | 定义一个刚体（link）                  |
|              | `<joint name="..." type="...">`                                | 定义连接两个 link 的关节               |
| **几何形状**     | `<box size="x y z"/>`                                          | 立方体几何体                        |
|              | `<cylinder radius="r" length="l"/>`                            | 圆柱体几何体                        |
|              | `<sphere radius="r"/>`                                         | 球体几何体                         |
|              | `<mesh filename="..." scale="x y z"/>`                         | 使用 STL/DAE 格式的网格模型            |
| **视觉与碰撞**    | `<visual>...</visual>`                                         | 可视化模型设置                       |
|              | `<collision>...</collision>`                                   | 碰撞检测模型设置                      |
|              | `<geometry>...</geometry>`                                     | 指定几何形状（用于 visual 或 collision） |
| **惯性**       | `<inertial>`                                                   | 描述质量与惯性信息                     |
|              | `<mass value="..."/>`                                          | 质量值（kg）                       |
|              | `<inertia ixx="..." ixy="..." .../>`                           | 转动惯量矩阵各项                      |
| **位置与姿态**    | `<origin xyz="x y z" rpy="r p y"/>`                            | 设置相对位置和姿态（单位：米和弧度）            |
| **关节属性**     | `<parent link="..."/>`                                         | 父 link 名称                     |
|              | `<child link="..."/>`                                          | 子 link 名称                     |
|              | `<axis xyz="x y z"/>`                                          | 运动轴向（旋转/移动）                   |
|              | `<limit lower="..." upper="..." effort="..." velocity="..."/>` | 设置关节运动范围与能力                   |
| **材质**       | `<material name="...">`                                        | 定义材质                          |
|              | `<color rgba="r g b a"/>`                                      | 定义颜色                          |
| **Xacro 支持** | `<xacro:include filename="..."/>`                              | 引入外部 xacro 文件（仅在 Xacro 中）     |
|              | `<xacro:property name="..." value="..."/>`                     | 定义变量（仅在 Xacro 中）              |
|              | `<xacro:macro name="..." params="...">`                        | 定义宏模板（仅在 Xacro 中）             |


- `<robot> `机器人总结构

    | 参数     | 含义    | 示例         |
    | ------ | ----- | ---------- |
    | `name` | 机器人名称 | `my_robot` |

- `<link>` 刚体定义

    | 子标签           | 参数/属性                         | 含义           |
    | ------------- | ----------------------------- | ------------ |
    | `<visual>`    | 显示相关内容                        | 仅用于 RViz 可视化 |
    | `<collision>` | 碰撞模型                          | 用于物理引擎或碰撞检测  |
    | `<geometry>`  | `box` / `cylinder` / `mesh` 等 | 几何形状定义       |
    | `<inertial>`  | 质量属性                          | 含质量、惯性张量     |

- `<geometry>` 几何定义

    | 标签           | 参数                | 含义                     | 示例                         |
    | ------------ | ----------------- | ---------------------- | -------------------------- |
    | `<box>`      | `size="x y z"`    | 长宽高（单位：m）              | `size="1 0.5 0.3"`         |
    | `<cylinder>` | `radius` `length` | 半径和长度                  | `radius="0.1"`             |
    | `<sphere>`   | `radius`          | 半径                     | `radius="0.2"`             |
    | `<mesh>`     | `filename`        | STL/DAE 路径（支持 ROS pkg） | `filename="package://..."` |
    |              | `scale`           | 缩放因子（xyz）              | `scale="1 1 1"`            |

- `<material>` 材质设置

    | 属性/参数     | 含义               | 示例               |                          |
    | --------- | ---------------- | ---------------- | ------------------------ |
    | `name`    | 材质名（可复用）         | `red`, `metal` 等 |                          |
    | `<color>` | `rgba="r g b a"` | 红绿蓝透明度（0-1）      | `rgba="1 0 0 1"` 表示不透明红色 |

- `<inertial>` 质量与惯性张量

    | 标签          | 参数                                       | 含义       | 示例                    |
    | ----------- | ---------------------------------------- | -------- | --------------------- |
    | `<mass>`    | `value`                                  | 质量（kg）   | `1.0`                 |
    | `<inertia>` | `ixx`, `ixy`, `ixz`, `iyy`, `iyz`, `izz` | 惯性矩阵六个分量 | 常为对称矩阵，例如 `ixx="0.1"` |

- `<joint>` 关节定义

    属性与基本结构
    | 属性/标签      | 参数     | 含义                                               | 示例          |
    | ---------- | ------ | ------------------------------------------------ | ----------- |
    | `name`     | 名称     | 关节唯一标识                                           | `joint1`    |
    | `type`     | 类型     | `revolute`, `prismatic`, `fixed`, `continuous` 等 |             |
    | `<parent>` | `link` | 父级 link 名                                        | `base_link` |
    | `<child>`  | `link` | 子级 link 名                                        | `link1`     |

- `<origin>` 定义位置和姿态

    | 参数    | 含义                           | 示例               |
    | ----- | ---------------------------- | ---------------- |
    | `xyz` | 相对父 link 的位置（米）              | `xyz="0 0 0.5"`  |
    | `rpy` | 相对姿态（roll, pitch, yaw，单位：弧度） | `rpy="0 0 1.57"` |

- `<axis>` 旋转/滑动方向

    | 参数    | 含义         | 示例            |
    | ----- | ---------- | ------------- |
    | `xyz` | 表示运动轴的方向向量 | `xyz="0 0 1"` |

- `<limit>`（非 fixed 关节适用）

    | 参数         | 含义                 | 示例      |
    | ---------- | ------------------ | ------- |
    | `lower`    | 运动最小角/长度（单位：弧度/米）  | `-1.57` |
    | `upper`    | 运动最大角/长度           | `1.57`  |
    | `effort`   | 关节最大扭矩或力（单位：N·m/N） | `10.0`  |
    | `velocity` | 最大速度（rad/s 或 m/s）  | `1.0`   |

-  `Xacro` 特有（可选）

    | 标签 / 属性            | 含义            | 示例                                  |
    | ------------------ | ------------- | ----------------------------------- |
    | `<xacro:include>`  | 引入外部 xacro 文件 | `filename="$(find my_pkg)/x.xacro"` |
    | `<xacro:property>` | 定义变量          | `name="L1" value="1.0"`             |
    | `<xacro:macro>`    | 定义可复用的宏       | `<xacro:macro name="leg" ...>`      |
