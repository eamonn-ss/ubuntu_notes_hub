# PICO 遥操机器人项目搭建流程

## 一、Unity 项目搭建

### 1. 安装 Unity Editor

打开 Unity Hub，并安装 Unity Editor。

本项目使用的 Unity 版本为：

```text
Unity 2022.3.62f3
```

建议尽量保持 Unity 版本一致，避免 PICO SDK、XR Interaction Toolkit、ROS TCP Connector 等插件出现兼容性问题。

---

### 2. 新建 Unity 项目

在 Unity Hub 中新建项目，选择：

```text
3D Core
```

然后点击创建。

---

### 3. 进入 Unity 项目

项目创建完成后，进入 Unity 编辑器。

初始场景通常包含：

```text
SampleScene
├── Main Camera
└── Directional Light
```

后续会使用 PICO XR Rig，因此默认的 `Main Camera` 可以在 Scene 搭建阶段删除。

---

## 二、Android Build Settings 配置

由于软件最终需要安装到 PICO 头显中运行，因此 Unity 构建平台必须切换为 Android。

### 1. 检查 Android 构建模块

在 Unity 顶部菜单栏中打开：

```text
File -> Build Settings
```

查看左侧平台列表中的 `Android` 是否可用。

如果 `Android` 是灰色，说明当前 Unity Editor 没有安装 Android 构建模块，需要先安装 Android Build Support。

![alert text](https://i.postimg.cc/xT3Tn8fs/4.png)

---

### 2. 安装 Android Build Support

如果 `Android` 是灰色，需要先退出 Unity 编辑器，然后打开 Unity Hub。

进入：

```text
Installs -> 找到当前使用的 Unity Editor 版本 -> Manage -> Add modules
```

勾选以下模块：

```text
Android Build Support
Android SDK & NDK Tools
OpenJDK
```

安装完成后，重新打开 Unity 项目。

![alert text](https://i.postimg.cc/ZKSKGpSW/5.png)

![alert text](https://i.postimg.cc/wTQTgMq5/6.png)
---

### 3. 切换构建平台为 Android

重新进入 Unity 后，打开：

```text
File -> Build Settings
```

执行以下操作：

```text
1. 点击 Add Open Scenes，将当前 SampleScene 加入 Scenes In Build
2. 选择 Android
3. 点击 Switch Platform
4. 等待 Unity 重新导入资源
```

切换完成后，`Android` 图标右侧应该出现 Unity 小图标，表示当前构建平台已经切换为 Android。

![alert text](https://i.postimg.cc/XYNNJWq1/7.png)

---

### 4. 配置 Player Settings

在 Build Settings 窗口中点击：

```text
Player Settings...
```

或者通过菜单进入：

```text
Edit -> Project Settings -> Player
```

切换到 Android 配置页。

重点修改：

```text
Package Name
```

不要使用默认包名：

```text
com.DefaultCompany.xxx
```

建议改成自己的包名，例如：

```text
com.eamon.picoposepublisher
```

Unity 的 Project Settings 一般会自动保存，不需要额外点击保存按钮。

![alert text](https://i.postimg.cc/ZKSKGpSv/8.png)

![alert text](https://i.postimg.cc/zBh8MX28/9.png)

![alert text](https://i.postimg.cc/zXFX8vzG/10.png)

---

### 5. 检查 Android 工具链路径

打开：

```text
Edit -> Preferences -> External Tools
```

检查以下路径是否正常：

```text
Android SDK
Android NDK
OpenJDK
```

如果使用 Unity Hub 安装了 Android Build Support，通常这些路径会自动配置好。

![alert text](https://i.postimg.cc/xdh9tb5V/11.png)

---

## 三、导入 SDK 和插件

本项目主要需要以下插件：

```text
PICO Unity Integration SDK
XR Interaction Toolkit
ROS TCP Connector
```

---

## 四、导入 PICO Unity Integration SDK

### 1. 下载 PICO SDK

前往 PICO Unity Integration SDK 下载页面：

```text
https://github.com/Pico-Developer/PICO-Unity-Integration-SDK
```

本项目使用版本：

```text
PICO Unity Integration SDK 3.1.0
```

下载完成后，解压 SDK 压缩包。

解压后应得到一个包含 `package.json` 文件的文件夹。

---

### 2. 通过 Package Manager 导入 PICO SDK

回到 Unity 编辑器，打开：

```text
Window -> Package Manager
```

点击左上角：

```text
+ -> Add package from disk
```

选择 PICO SDK 文件夹中的：

```text
package.json
```

然后导入。

导入完成后，Unity 可能会弹出 `PXR SDK Setting` 窗口，直接关闭即可。

![alert text](https://i.postimg.cc/4x44dGnX/12.png)

---

### 3. 启用 New Input System

导入 PICO SDK 后，Unity 可能会弹出提示，大意是：

```text
项目已经安装或使用了 New Input System，但 Player Settings 中还没有启用新的输入后端。
```

如果不启用新的输入后端，XR 手柄、键盘、控制器等输入可能无法正常传入 Unity。

此时选择：

```text
Yes
```

随后 Unity 可能会要求应用设置并重启，选择：

```text
Apply
Close
```

等待 Unity 重启。

![alert text](https://i.postimg.cc/GpVbqsK0/13.png)
---

### 4. 检查 Active Input Handling

进入：

```text
Edit -> Project Settings -> Player -> Other Settings
```

找到：

```text
Active Input Handling
```

原来可能是：

```text
Input Manager (Old)
```

建议改成：

```text
Input System Package (New)
```

或者：

```text
Both
```

如果只使用旧输入系统，可能会导致 XR 手柄输入无法正常工作。

---

## 五、导入 XR Interaction Toolkit

打开：

```text
Window -> Package Manager
```

在 Package Manager 中找到并安装：

```text
XR Interaction Toolkit
```

安装完成后，点击 `XR Interaction Toolkit`，右侧会看到：

```text
Description
Version History
Dependencies
Samples
```

点击：

```text
Samples
```

导入以下两个 Sample：

```text
Starter Assets
XR Device Simulator
```

导入方式是点击右侧的：

```text
Import
```

导入完成后，Project 面板中通常会出现类似目录：

```text
Assets/Samples/XR Interaction Toolkit/...
Assets/XRI/
```

![alert text](https://i.postimg.cc/sgnjGLZX/14.png)

---

## 六、导入 ROS TCP Connector

打开：

```text
Window -> Package Manager
```

点击左上角：

```text
+ -> Add package from git URL
```

输入 ROS TCP Connector 仓库地址：

```text
https://github.com/Unity-Technologies/ROS-TCP-Connector.git
```

本项目建议安装指定版本：

```text
https://github.com/Unity-Technologies/ROS-TCP-Connector.git?path=/com.unity.robotics.ros-tcp-connector#v0.7.0
```

如果通过 URL 安装失败，可以将仓库下载到本地，然后选择本地 `package.json` 安装，例如：

```text
/home/eamon/sdk/ROS-TCP-Connector/com.unity.robotics.ros-tcp-connector/package.json
```

![alert text](https://i.postimg.cc/RVLV4hSC/15.png)

---

## 七、启用 PICO XR Provider

如果 Unity 出现类似提示：

```text
[PICO XR Required] PICO XR plugin needs to be enabled and unique.
```

说明当前 Android 平台下还没有正确启用 PICO XR Provider，或者同时启用了多个 XR Provider。

进入：

```text
Edit -> Project Settings -> XR Plug-in Management
```

在右侧上方选择：

```text
Android 小机器人图标
```

也就是 Android 平台标签页。

在 Android 标签页中找到：

```text
Plug-in Providers
```

勾选：

```text
PICO
```

也就是：

```text
[x] PICO
```

如果同时存在其他 XR Provider，例如：

```text
OpenXR
Oculus
ARCore
Unity Mock HMD
```

建议全部取消勾选，只保留：

```text
PICO
```

这里的 `enabled and unique` 含义是：

```text
PICO XR Provider 必须启用，并且必须是唯一启用的 XR 插件。
```

![alert text](https://i.postimg.cc/qRK4YMDz/16.png)

---

## 八、切换 Robotics ROS 协议为 ROS2

由于本项目连接的是 ROS2，因此需要将 Unity Robotics 的 ROS 协议从 ROS1 切换为 ROS2。

打开：

```text
Robotics -> ROS Settings
```

设置：

```text
Protocol = ROS2
ROS IP Address = 192.168.10.202
ROS Port = 10000
```

其中：

```text
ROS IP Address
```

应填写运行 `ros_tcp_endpoint` 的 ROS 电脑 IP，不要填写 `127.0.0.1`。

本项目使用：

```text
192.168.10.202
```

![alert text](https://i.postimg.cc/YCXrLPL5/17.png)

---

# 九、Scene 搭建

## 1. 整理当前场景

Unity 新建 3D 项目后，Hierarchy 通常为：

```text
SampleScene
├── Main Camera
└── Directional Light
```

由于后续会使用 PICO XR Rig，因此需要删除默认的 `Main Camera`。

操作：

```text
Hierarchy -> 选中 Main Camera -> Delete
```

保留：

```text
Directional Light
```

![alert text](https://i.postimg.cc/JhvRPBxz/18.png)

---

## 2. 添加 PICO Video Seethrough XR Origin

在 Hierarchy 空白处右键，选择：

```text
PICO Building Blocks -> PICO Video Seethrough XR Origin (XR Rig)
```

添加完成后，场景中会出现类似结构：

```text
[Building Block] PICO Video Seethrough Effect XR Origin (XR Rig)
└── Camera Offset
    ├── Main Camera
    ├── Left Controller
    └── Right Controller
```

该 XR Rig 用于：

```text
1. PICO 头显追踪
2. 左右手柄追踪
3. 视频透视 Video Seethrough
4. 后续 ROS 图像与状态 UI 显示
```

![alert text](https://i.postimg.cc/SKJy6GWG/19.png)

---

## 3. 创建 PosePublisherObject

在 Hierarchy 空白处右键：

```text
Create Empty
```

命名为：

```text
PosePublisherObject
```

该对象用于挂载位姿发布脚本：

```text
PosePublisher.cs
```

![alert text](https://i.postimg.cc/9frWdBGN/20.png)

---

## 4. 创建 Scripts 文件夹和 PosePublisher.cs

在底部 Project 面板的 `Assets` 下右键：

```text
Create -> Folder
```

命名为：

```text
Scripts
```

进入 `Scripts` 文件夹，右键：

```text
Create -> C# Script
```

命名为：

```text
PosePublisher
```

对应脚本文件为：

```text
PosePublisher.cs
```

该脚本用于将 PICO 头显和左右手柄位姿发布到 ROS2。

---

## 5. 创建 CameraStream 文件夹和 RosImageDisplayManager.cs

在底部 Project 面板的 `Assets` 下右键：

```text
Create -> Folder
```

命名为：

```text
CameraStream
```

进入 `CameraStream` 文件夹，右键：

```text
Create -> C# Script
```

命名为：

```text
RosImageDisplayManager
```

对应脚本文件为：

```text
RosImageDisplayManager.cs
```

该脚本用于接收 ROS2 中的压缩图像话题，并在 PICO 头显中以 Quad 方式显示图像。

注意：如果项目中旧脚本名为：

```text
RosCompressedImageQuadDisplay.cs
```

建议统一改为：

```text
RosImageDisplayManager.cs
```

并确保脚本文件名和类名一致：

```text
RosImageDisplayManager
```

避免出现 Unity `Missing Script` 或类名不匹配问题。

---

## 6. 挂载 PosePublisher.cs

选中：

```text
PosePublisherObject
```

在右侧 Inspector 中点击：

```text
Add Component
```

搜索并添加：

```text
PosePublisher
```

然后绑定以下 Transform：

```text
Head Transform             <- Main Camera
Left Controller Transform  <- Left Controller
Right Controller Transform <- Right Controller
```

也就是从 Hierarchy 中拖入：

```text
[Building Block] PICO Video Seethrough XR Origin (XR Rig)
└── Camera Offset
    ├── Main Camera        -> Head Transform
    ├── Left Controller    -> Left Controller Transform
    └── Right Controller   -> Right Controller Transform
```

![alert text](https://i.postimg.cc/FK8hDJp1/21.png)

---

## 7. 配置 PosePublisher 参数

推荐配置如下：

```text
Head Topic  = /head_pose
Left Topic  = /left_pose
Right Topic = /right_pose
Frame Id    = robot_base

Ros IP      = 192.168.10.202
Ros Port    = 10000
Use Saved IP = true

Publish Frequency = 30
Publish Head Always = true
Require Calibration For Controllers = true

Force Publish Left  = false
Force Publish Right = false
```

无 PICO 真机调试时，可以临时设置：

```text
Require Calibration For Controllers = false
Force Publish Left  = true
Force Publish Right = true
```

正式打包到 PICO 头显时，建议恢复为：

```text
Require Calibration For Controllers = true
Force Publish Left  = false
Force Publish Right = false
```

---

## 8. 创建 RosImageDisplayManager 对象

在 Hierarchy 空白处右键：

```text
Create Empty
```

命名为：

```text
RosImageDisplayManager
```

选中该对象，在 Inspector 中点击：

```text
Add Component
```

搜索并添加：

```text
RosImageDisplayManager
```

![alert text](https://i.postimg.cc/yNt7vSjz/24.png)

---

## 9. 配置 RosImageDisplayManager 参数

推荐配置如下：

```text
Ros Topic = /camera/head/head_camera/color/image_raw/compressed
Ros IP Address = 192.168.10.202
Ros Port = 10000
Use Saved IP = true

Target Camera = Main Camera
Auto Find Main Camera = true

Show Image On Start = true
Image Display Enabled = true
Pause Decode When Hidden = true

Display Mode = WorldLocked
Quad Distance = 3.0
Quad Offset X = 0.9
Quad Offset Y = -0.35
Quad Scale = 0.35
Fixed Aspect = 1.3333

Enable Transparency = true
Image Opacity = 0.7
Max Decode FPS = 15
```

本项目实际使用的 ROS 图像话题为：

```text
/camera/head/head_camera/color/image_raw/compressed
```

通过 ROS2 检查得到图像尺寸为：

```text
640 x 480
```

因此宽高比应设置为：

```text
Fixed Aspect = 640 / 480 = 1.3333
```

---

## 10. 图像显示模式说明

`RosImageDisplayManager` 支持三种图像显示模式：

```text
HeadLocked
WorldLocked
SoftFollow
```

### HeadLocked

```text
图像窗口固定在头显视野中。
头显转到哪里，图像就跟到哪里。
```

优点：

```text
方便调试，始终能看到图像。
```

缺点：

```text
容易遮挡真实透视场景。
```

---

### WorldLocked

```text
图像窗口在启动时放置到真实空间中的固定位置。
头显转动时，图像不会一直跟随视野。
```

优点：

```text
适合 PICO 透视场景。
不会持续遮挡正前方真实场景。
```

本项目推荐使用：

```text
Display Mode = WorldLocked
```

---

### SoftFollow

```text
图像窗口会缓慢跟随头显。
不会像 HeadLocked 那样强制贴在视野中间。
```

适合需要图像大致跟随，但又不希望明显遮挡视野的场景。

---

## 11. 创建状态 UI

为了在 PICO 头显中显示系统状态，需要创建一个 World Space Canvas。

建议结构如下：

```text
[Building Block] PICO Video Seethrough Effect XR Origin (XR Rig)
└── Camera Offset
    └── Main Camera
        └── StatusCanvas
            └── StatusText_TMP
```

---

### 11.1 创建 StatusCanvas

在 `Main Camera` 下右键：

```text
UI -> Canvas
```

命名为：

```text
StatusCanvas
```

设置 Canvas：

```text
Render Mode = World Space
Event Camera = Main Camera
Layer = UI
```

RectTransform 推荐参数：

```text
Pos X = -0.55
Pos Y = -0.42
Pos Z = 1.2

Rotation X = 0
Rotation Y = 0
Rotation Z = 0

Scale X = 0.001
Scale Y = 0.001
Scale Z = 0.001

Width = 650
Height = 220
```

![alert text](https://i.postimg.cc/wTQTgMqV/22.png)

---

### 11.2 创建 StatusText_TMP

在 `StatusCanvas` 下创建：

```text
UI -> Text - TextMeshPro
```

命名为：

```text
StatusText_TMP
```

推荐参数：

```text
Width = 620
Height = 200
Font Size = 28 ~ 36
Alignment = Left + Top
Wrapping = Enabled
Overflow = Overflow
Raycast Target = false
```

如果中文显示为方框，说明默认 TMP 字体不支持中文。调试阶段可以先使用英文状态文本；正式版本建议导入中文字体，并生成 TMP Font Asset。

![alert text](https://i.postimg.cc/G2DdNhgp/23.png)
---

### 11.3 绑定状态文本

选中：

```text
PosePublisherObject
```

在 `PosePublisher` 脚本中找到：

```text
Status Text TMP
```

将 Hierarchy 中的：

```text
StatusText_TMP
```

拖入该字段。
---

## 12. 关闭手柄射线显示

PICO Building Block 默认可能会给左右手柄添加射线显示，用于 UI 点击或远距离交互。

如果进入头显后看到红色引导线，而当前项目不需要手柄射线，可以关闭。

分别选中：

```text
Left Controller
Right Controller
```

在 Inspector 中关闭以下组件：

```text
XR Ray Interactor
Line Renderer
XR Interactor Line Visual
```

保留：

```text
XR Controller (Action-based)
```

不要关闭 `XR Controller (Action-based)`，否则可能影响手柄追踪和输入。

关闭射线不会影响：

```text
PosePublisher 位姿发布
手柄按钮读取
夹爪状态读取
相机画面开关
```

---

# 十、ROS 端检查

## 1. 启动 ROS TCP Endpoint

在 ROS2 电脑上启动：

```bash
ros2 launch ros_tcp_endpoint endpoint.py
```

确认端口监听：

```bash
ss -lntp | grep 10000
```

正常应能看到 `10000` 端口处于监听状态。

---

## 2. 检查图像话题

查看图像话题：

```bash
ros2 topic list | grep image
```

本项目使用：

```text
/camera/head/head_camera/color/image_raw/compressed
```

检查话题类型和发布者：

```bash
ros2 topic info /camera/head/head_camera/color/image_raw/compressed
```

正常结果应类似：

```text
Type: sensor_msgs/msg/CompressedImage
Publisher count: 1
Subscription count: 1
```

检查帧率：

```bash
ros2 topic hz /camera/head/head_camera/color/image_raw/compressed
```

如果有稳定帧率，Unity 才能收到图像。

---

## 3. 检查图像尺寸

对应原始图像话题通常为：

```text
/camera/head/head_camera/color/image_raw
```

执行：

```bash
ros2 topic echo /camera/head/head_camera/color/image_raw --once | head -n 30
```

在输出中查看：

```text
height
width
encoding
```

例如：

```text
height: 480
width: 640
encoding: rgb8
```

则 Unity 中应设置：

```text
Fixed Aspect = 640 / 480 = 1.3333
```

---

## 4. 检查位姿话题

Unity 运行后，在 ROS2 电脑上查看：

```bash
ros2 topic list
```

应能看到：

```text
/head_pose
/left_pose
/right_pose
```

查看头显位姿：

```bash
ros2 topic echo /head_pose
```

查看左右手柄位姿：

```bash
ros2 topic echo /left_pose
ros2 topic echo /right_pose
```

---

# 十一、Build And Run 到 PICO

完成以上配置后，执行：

```text
Ctrl + S 保存场景
File -> Build Settings
Build And Run
```

构建前确认：

```text
Platform = Android
Scene 已加入 Scenes In Build
XR Plug-in Management Android 下只启用 PICO
ROS Settings Protocol = ROS2
ROS IP Address = 192.168.10.202
ROS Port = 10000
```

---

# 十二、最终推荐场景结构

最终 Hierarchy 推荐结构如下：

```text
SampleScene
├── Directional Light
├── XR Interaction Manager
├── [Building Block] PICO Video Seethrough Effect XR Origin (XR Rig)
│   └── Camera Offset
│       ├── Main Camera
│       │   └── StatusCanvas
│       │       └── StatusText_TMP
│       ├── Left Controller
│       └── Right Controller
├── PosePublisherObject
├── RosImageDisplayManager
└── EventSystem
```

---

# 十三、常见问题排查

## 1. Unity 一直显示等待 ROS 图像

如果 Console 中一直显示：

```text
[RosImageDisplayManager] 等待 ROS 图像中
```

需要检查 ROS 端：

```bash
ros2 topic info /camera/head/head_camera/color/image_raw/compressed
ros2 topic hz /camera/head/head_camera/color/image_raw/compressed
```

如果 `Publisher count = 0`，说明该话题没有发布者，Unity 无法收到图像。

---

## 2. ROS2 协议不匹配

如果出现：

```text
Incompatible protocol: ROS-TCP-Endpoint is using ROS2, but Unity is in ROS1 mode.
```

需要打开：

```text
Robotics -> ROS Settings
```

将：

```text
Protocol = ROS2
```

---

## 3. 头显中图像遮挡真实场景

建议使用：

```text
Display Mode = WorldLocked
Quad Scale = 0.35
Image Opacity = 0.7
Quad Offset X = 0.9
Quad Offset Y = -0.35
```

如果仍然遮挡，可以进一步减小：

```text
Quad Scale = 0.25
Image Opacity = 0.6
```

---

## 4. 需要临时隐藏相机画面

`RosImageDisplayManager` 支持相机画面开关：

```text
Show Image On Start
Image Display Enabled
Pause Decode When Hidden
```

如果接入 UI Button，可以调用：

```text
RosImageDisplayManager -> ToggleImageDisplay()
```

点击一次显示，再点一次隐藏。

---

## 5. 手柄没有识别

如果 Console 中显示：

```text
XR Device 状态：Head=False, Left=False, Right=False
```

在没有连接 PICO 真机时，这是正常现象。

如果已经连接 PICO 真机仍然显示无效，需要检查：

```text
PICO 设备是否连接
XR Plug-in Management 是否启用 PICO
Input System 是否启用
XR Controller 是否正常
```

---

# 十四、推荐最终参数汇总

## RosImageDisplayManager

```text
Ros Topic = /camera/head/head_camera/color/image_raw/compressed
Ros IP Address = 192.168.10.202
Ros Port = 10000
Use Saved IP = true

Target Camera = Main Camera

Show Image On Start = true
Image Display Enabled = true
Pause Decode When Hidden = true

Display Mode = WorldLocked
Quad Distance = 3.0
Quad Offset X = 0.9
Quad Offset Y = -0.35
Quad Scale = 0.35
Fixed Aspect = 1.3333

Enable Transparency = true
Image Opacity = 0.7
Max Decode FPS = 15
```

---

## PosePublisher

```text
Head Topic = /head_pose
Left Topic = /left_pose
Right Topic = /right_pose
Frame Id = robot_base

Ros IP = 192.168.10.202
Ros Port = 10000
Use Saved IP = true

Publish Frequency = 30
Publish Head Always = true
Require Calibration For Controllers = true

Force Publish Left = false
Force Publish Right = false
```

---

# 十五、整体流程总结

```text
安装 Unity 2022.3.62f3
↓
新建 3D 项目
↓
安装 Android Build Support
↓
切换 Android 平台
↓
导入 PICO Unity Integration SDK
↓
导入 XR Interaction Toolkit
↓
导入 ROS TCP Connector
↓
启用 PICO XR Provider
↓
Robotics 设置为 ROS2
↓
添加 PICO Video Seethrough XR Origin
↓
创建 PosePublisherObject
↓
创建 RosImageDisplayManager
↓
创建 StatusCanvas 和 StatusText_TMP
↓
配置 ROS 图像话题和位姿话题
↓
ROS 端启动 ros_tcp_endpoint
↓
Unity Play 测试
↓
Build And Run 到 PICO
```