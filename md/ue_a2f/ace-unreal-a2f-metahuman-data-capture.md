# NVIDIA ACE Unreal Plugin：Audio2Face-3D 与 MetaHuman 数据采集指南

> 环境：Unreal Engine 5.6.x + NVIDIA ACE Audio2Face-3D + MetaHuman
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[facegood-metahuman-dataset-rebuild.md](facegood-metahuman-dataset-rebuild.md)


## 1. 文档说明

本文记录在 **Unreal Engine 5.6.x** 中配置 NVIDIA ACE Audio2Face-3D、驱动 MetaHuman，并通过自定义 C++ 组件同步采集以下数据的完整流程：

- 输入 WAV 音频；
- MetaHuman 面部图像帧；
- NVIDIA ACE 输出的 52 维 ARKit 动画曲线；
- 每帧时间戳与阶段标记；
- Session 元数据。

> 本文中的菜单名称以英文界面为主，中文界面可根据对应含义查找。

---

# 2. 安装前准备

## 2.1 安装 Unreal Engine

通过 Epic Games Launcher 安装目标 Unreal Engine 版本，例如：

```text
Unreal Engine 5.6.x
```

安装引擎时，应勾选：

```text
MetaHuman Creator Core Data
```

该内容是 UE 5.6 及以上版本在编辑器内创建和装配 MetaHuman 所需的附加数据。

![示例图片](https://i.postimg.cc/HLHccPqV/3.png)

## 2.2 安装 Visual Studio

安装 Visual Studio 2022，并至少勾选：

```text
使用 C++ 的游戏开发
```

建议同时安装：

- Windows 10/11 SDK；
- MSVC C++ 编译工具；
- .NET SDK；
- Unreal Engine 相关工具。

可参考 UE 开发手册中的 [Setting Up Visual Studio](https://dev.epicgames.com/documentation/unreal-engine/setting-up-visual-studio-development-environment-for-cplusplus-projects-in-unreal-engine)

## 2.3 安装 NVIDIA ACE Unreal Plugin

下载与当前 Unreal Engine 版本兼容的 NVIDIA ACE Unreal Plugin。

对于 Epic Games Launcher 安装的引擎，可将插件目录放置到：

```text
D:\UnrealEngine\UE_5.6\Engine\Plugins\Marketplace
```

若 `Marketplace` 目录不存在，可手动创建。

安装后重新启动 Unreal Editor。


> 必须确认 ACE 插件版本与 Unreal Engine 版本兼容。不同版本的目录结构、节点名称或模型接口可能存在差异。

![示例图片](https://i.postimg.cc/pdxhh1wm/1.png)

![示例图片](https://i.postimg.cc/q70hhZPh/2.png)

---

# 3. 创建 Audio2Face-3D 项目

## 3.1 创建空白项目

1. 打开 Unreal Engine。
2. 选择目标引擎版本，例如 UE 5.6.x。
3. 创建一个空白项目。
4. 建议启用 C++ 支持，或在后续通过 `Tools → New C++ Class` 添加 C++ 类。
![示例图片](https://i.postimg.cc/W3Yhyphg/4.png)

![示例图片](https://i.postimg.cc/G2gHf3Hk/5.png)

## 3.2 打开 Content Browser

如果界面中没有 Content Browser：

```text
Window
→ Content Browser
→ Content Browser 1
```
![示例图片](https://i.postimg.cc/76tfRPfn/6.png)
![示例图片](https://i.postimg.cc/0j6b1gwM/7.png)

## 3.3 启用插件

进入：

```text
Edit
→ Plugins
```

搜索并启用所需插件：

```text
NVIDIA ACE
MetaHuman Creator
MetaHuman Core Tech
```

启用后点击：

```text
Restart Now
```
![示例图片](https://i.postimg.cc/wMt7YKmm/8.png)

![示例图片](https://i.postimg.cc/vT1cwRV6/9.png)

![示例图片](https://i.postimg.cc/J0yGCwkZ/10.png)
## 3.4 创建并保存关卡

进入：

```text
File
→ New Level
→ Basic
→ Create
```

然后保存：

```text
File
→ Save Current Level
```
![示例图片](https://i.postimg.cc/904rH37P/11.png)
![示例图片](https://i.postimg.cc/Fzf7XtSt/12.png)
![示例图片](https://i.postimg.cc/Fzf7XtLM/13.png)
![示例图片](https://i.postimg.cc/904rH37L/14.png)
---

# 4. 创建 MetaHuman

## 4.1 创建 MetaHuman Character

在 Content Browser 中右键：

```text
MetaHuman
→ MetaHuman Character
```

命名示例：

```text
MyMH
```
![示例图片](https://i.postimg.cc/brKdz60c/15.png)
![示例图片](https://i.postimg.cc/RhjqMP78/16.png)
![示例图片](https://i.postimg.cc/RhjqMP19/17.png)
## 4.2 配置人物

双击 `MyMH`，进入 MetaHuman Creator：

1. 选择一个 Preset。
2. 点击 `Apply Preset`。
3. 下载纹理源数据。
4. 点击 `Create Full Rig`。
5. 进入 Assemble。
6. Assembly Selection 选择：

```text
UE Cine Complete
```

7. 点击绿色 `Assemble`。
8. 保存并退出。

完成后，Content Browser 中会生成 MetaHuman 相关目录。
![示例图片](https://i.postimg.cc/RhjqMP78/16.png)
![示例图片](https://i.postimg.cc/RhjqMP19/17.png)
![示例图片](https://i.postimg.cc/6qDT9HV5/18.png)
## 4.3 将 MetaHuman 放入场景

进入类似目录：

```text
Content/MetaHumans/MyMH/
```

找到：

```text
BP_MyMH
```

将其拖入场景，并调整 Transform。

![示例图片](https://i.postimg.cc/nr6MHdKX/19.png)
![示例图片](https://i.postimg.cc/gc5xq0CV/20.png)
![示例图片](https://i.postimg.cc/HWKr4LqB/21.png)
---

# 5. 配置 NVIDIA ACE 面部动画

## 5.1 添加 ACE Audio Curve Source

在 Outliner 中选择 `BP_MyMH`，打开蓝图并选择 `Face` 组件。

点击：

```text
Add
```

搜索并添加：

```text
ACE Audio Curve Source
```
![示例图片](https://i.postimg.cc/v8j4LmJK/22.png)
![示例图片](https://i.postimg.cc/SQ5n7s0F/23.png)
## 5.2 创建 Face Animation Blueprint

进入：

```text
/All/Game/MetaHumans/Common/Face
```

选择：

```text
Face_Archetype_Skeleton
```

右键：

```text
Create
→ Anim Blueprint
```

命名为：

```text
Face_AnimBP
```

回到 `BP_MyMH` 的 `Face` 组件，将：

```text
Animation Mode = Use Animation Blueprint
Anim Class = Face_AnimBP
```
![示例图片](https://i.postimg.cc/gc5xqJ9m/24.png)
![示例图片](https://i.postimg.cc/7Y2fBkDk/25.png)
## 5.3 配置 AnimGraph

打开 `Face_AnimBP`，在 AnimGraph 中建立：

```text
Input Pose
    ↓
Apply ACE Face Animations
    ↓
mh_arkit_mapping_pose_A2F
    ↓
Output Pose
```

编译并保存。

> `Apply ACE Face Animations` 只输出动画曲线值。角色必须配置与 ARKit BlendShape 名称对应的 Pose Asset，才能把曲线转换为实际面部形变。

![示例图片](https://i.postimg.cc/zXgVdr5q/26.png)
![示例图片](https://i.postimg.cc/KvMR92FG/27.png)
---

# 6. 通过 WAV 驱动 MetaHuman

## 6.1 创建播放变量

打开 `BP_MyMH` 的 Event Graph。

添加按键事件，例如：

```text
S
```

添加节点：

```text
Animate Character From Wav File Async
```

常用输入包括：

```text
Target Actor
Path To Wav
ACE Emotion Parameters
A2F Provider Name
Parameter Helper
```

将 `Path To Wav`、`ACE Emotion Parameters`、`A2F Provider Name` 提升为变量。

示例 Provider：

```text
LocalA2F-James
```

或：

```text
LocalA2F-Claire
```

具体名称应以当前已安装并成功启动的 A2F Provider 为准。

![示例图片](https://i.postimg.cc/CLqzvgYR/28.png)
![示例图片](https://i.postimg.cc/VLCd781r/29.png)
![示例图片](https://i.postimg.cc/kXbBjm9S/30.png)
![示例图片](https://i.postimg.cc/XY6Xmz7q/31.png)
![示例图片](https://i.postimg.cc/Sxbj3vNj/32.png)
![示例图片](https://i.postimg.cc/6pxTgm58/33.png)
![示例图片](https://i.postimg.cc/Gmn9V5hD/34.png)
![示例图片](https://i.postimg.cc/t4G7wMCh/35.png)
![示例图片](https://i.postimg.cc/6pxTgm5r/36.png)
![示例图片](https://i.postimg.cc/9QHzKnFP/37.png)
![示例图片](https://i.postimg.cc/Hk1jRhs4/38.png)
![示例图片](https://i.postimg.cc/P5nN9Rry/39.png)

## 6.2 创建 Audio2Face Parameters

添加：

```text
Create Audio2Face Parameters
```

从返回值连接：

```text
Set Parameters From Struct
```

将 `Parameter Helper` 提升为变量。

![示例图片](https://i.postimg.cc/nhfMgPc0/40.png)
![示例图片](https://i.postimg.cc/zGY36cXd/41.png)
![示例图片](https://i.postimg.cc/Dw3mHMyj/42.png)
![示例图片](https://i.postimg.cc/CxpdXQLr/43.png)
![示例图片](https://i.postimg.cc/pLMy46X1/44.png)

## 6.3 启用按键输入

在 Event BeginPlay 中：

```text
Event BeginPlay
    ↓
Enable Input
```

`Player Controller` 连接：

```text
Get Player Controller
```

![示例图片](https://i.postimg.cc/fRQkprTp/45.png)
![示例图片](https://i.postimg.cc/YCNjHzh3/46.png)
![示例图片](https://i.postimg.cc/8zdsSmj4/47.png)
![示例图片](https://i.postimg.cc/sgP1r4vH/48.png)

## 6.4 测试播放

建议最终按键流程为：

```text
S Pressed
    ↓
Start Recording
    ↓
Create Audio2Face Parameters
    ↓
Set Parameters From Struct
    ↓
Animate Character From Wav File Async
```

当前 Recorder 已根据 WAV 时长自动停止，因此不建议再使用固定：

```text
Delay
→ Stop Recording
```

固定延迟可能导致短音频多录或长音频被提前截断。

---

# 7. 将常用参数公开到 Details 面板

在 `BP_MyMH` 蓝图左侧 Variables 中，将以下变量设置为 Instance Editable：

```text
Path To Wav
ACE Emotion Parameters
Parameter Helper
A2F Provider Name
```

可统一设置 Category：

```text
A2F
```

![示例图片](https://i.postimg.cc/rwGzkNKH/49.png)
![示例图片](https://i.postimg.cc/kgNDmvBZ/50.png)
![示例图片](https://i.postimg.cc/mg3hsytJ/51.png)
![示例图片](hhttps://i.postimg.cc/2Sd3D71p/52.png)
![示例图片](https://i.postimg.cc/fR7kNfVZ/53.png)

## 7.1 使用 Enum 管理模型

在 Content Browser 中右键：

```text
Blueprints
→ Enumeration
```

命名：

```text
A2F_Models
```

添加枚举项，例如：

```text
LocalA2F-Mark
LocalA2F-James
LocalA2F-Claire
```

在 `BP_MyMH` 中创建变量：

```text
A2F Model
```

类型：

```text
A2F_Models
```

变量容器类型应选择：

```text
Single
```

不要选择 Array。

通过 `Select` 或 `Switch on A2F_Models` 将枚举转换为对应的 Provider Name。

![示例图片](https://i.postimg.cc/kgNDmv2n/54.png)
![示例图片](https://i.postimg.cc/ht8hB1X4/55.png)
![示例图片](https://i.postimg.cc/bw0dh9ZN/56.png)
![示例图片](https://i.postimg.cc/Bn5t0Bjv/57.png)
![示例图片](https://i.postimg.cc/xd08TNmS/58.png)
![示例图片](https://i.postimg.cc/HLpns8Md/59-1.png)
![示例图片](https://i.postimg.cc/6Q9q54ZB/60.png)
![示例图片](https://i.postimg.cc/xd08TNm0/61.png)
![示例图片](https://i.postimg.cc/wB6MTRN7/62.png)

---

# 8. 创建 C++ 数据采集组件

## 8.1 创建组件类

在 Unreal Editor 中：

```text
Tools
→ New C++ Class
→ Actor Component
```

类名：

```text
A2FDataRecorderComponent
```

生成：

```text
Source/<项目名>/A2FDataRecorderComponent.h
Source/<项目名>/A2FDataRecorderComponent.cpp
```
![示例图片](https://i.postimg.cc/s2VxDGWB/63.png)
![示例图片](https://i.postimg.cc/jjs2dnf7/64.png)
![示例图片](https://i.postimg.cc/9fW0Fw99/65.png)
![示例图片](https://i.postimg.cc/FK9zskSy/66.png)

## 8.2 检查 API 宏

头文件中的 API 宏必须与项目模块名一致。

例如项目名为：

```text
TEST_A2F
```

则应使用：

```cpp
TEST_A2F_API
```

不要保留示例中的：

```cpp
YOURPROJECT_API
```

![示例图片](https://i.postimg.cc/tgXJCn6d/67.png)
![示例图片](https://i.postimg.cc/s2VxDGWc/68.png)
![示例图片](https://i.postimg.cc/6QY376V4/69.png)
![示例图片](https://i.postimg.cc/MGdTcZ0R/70.png)
## 8.3 Build.cs 依赖

建议使用：

```csharp
using UnrealBuildTool;

public class TEST_A2F : ModuleRules
{
    public TEST_A2F(ReadOnlyTargetRules Target) : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;

        PublicDependencyModuleNames.AddRange(
            new string[]
            {
                "Core",
                "CoreUObject",
                "Engine",
                "InputCore",
                "RenderCore",
                "Renderer",
                "ImageWrapper",
                "Json",
                "JsonUtilities"
            }
        );
    }
}
```

注意：

- C# 代码必须使用英文逗号和英文双引号；
- 不要写成中文全角符号，例如 `，`、`“”`；
- 如果项目中已有其他依赖，不要删除，只补充缺失模块。

## 8.4 编译注意事项

如果 Unreal Editor 正在运行 Live Coding，Visual Studio 的常规 Build 可能发生冲突。

推荐流程：

1. 关闭 Unreal Editor。
2. 在 Visual Studio 中选择：

```text
配置：Development Editor
平台：Win64
```

3. 右键项目模块并选择：

```text
Build
```

不要编译整个 Unreal Engine。

成功日志应包含：

```text
Result: Succeeded
```

如果组件未出现在蓝图组件搜索中：

1. 关闭 Unreal Editor；
2. 右键 `.uproject`；
3. 选择 `Generate Visual Studio project files`；
4. 重新编译；
5. 重新打开项目。

---

# 9. 将 Recorder 添加到 MetaHuman

## 9.1 添加组件

打开 `BP_MyMH`，在 Components 面板：

```text
Add
→ A2FDataRecorderComponent
```

组件树示例：

```text
BP_MyMH
├── Root
├── Body
├── Face
├── FaceCapture
└── A2FDataRecorder
```

![示例图片](https://i.postimg.cc/7Lm6CP11/71.png)

## 9.2 绑定 FaceMesh

将组件树中的：

```text
Face
```

拖入 Event Graph，选择：

```text
Get Face
```

将 Recorder 拖入 Event Graph，设置：

```text
Set Face Mesh
```

BeginPlay 流程：

```text
Event BeginPlay
    ↓
Set Face Mesh
    Face Mesh = Face
    ↓
Set Scene Capture
    Scene Capture = FaceCapture
    ↓
Enable Input
```

关键日志应显示：

```text
FaceMesh = Face
```

或：

```text
FaceMesh = Face_GEN_VARIABLE
```

不能是：

```text
FaceMesh = None
```

![示例图片](https://i.postimg.cc/xdtCkjG5/72.png)
![示例图片](https://i.postimg.cc/q7jRtBcL/73.png)
![示例图片](https://i.postimg.cc/XvQJZNKD/74.png)
![示例图片](https://i.postimg.cc/2526qjdM/75.png)
![示例图片](https://i.postimg.cc/yNvdJ6h2/76.png)
![示例图片](https://i.postimg.cc/MTHG1kt3/77.png)
![示例图片](https://i.postimg.cc/qRq72fQS/78.png)

---

# 10. 配置 52 维 ACE 动画曲线

NVIDIA ACE 输出以下 52 个 ARKit 兼容动画曲线：

```text
EyeBlinkLeft
EyeLookDownLeft
EyeLookInLeft
EyeLookOutLeft
EyeLookUpLeft
EyeSquintLeft
EyeWideLeft
EyeBlinkRight
EyeLookDownRight
EyeLookInRight
EyeLookOutRight
EyeLookUpRight
EyeSquintRight
EyeWideRight
JawForward
JawLeft
JawRight
JawOpen
MouthClose
MouthFunnel
MouthPucker
MouthLeft
MouthRight
MouthSmileLeft
MouthSmileRight
MouthFrownLeft
MouthFrownRight
MouthDimpleLeft
MouthDimpleRight
MouthStretchLeft
MouthStretchRight
MouthRollLower
MouthRollUpper
MouthShrugLower
MouthShrugUpper
MouthPressLeft
MouthPressRight
MouthLowerDownLeft
MouthLowerDownRight
MouthUpperUpLeft
MouthUpperUpRight
BrowDownLeft
BrowDownRight
BrowInnerUp
BrowOuterUpLeft
BrowOuterUpRight
CheekPuff
CheekSquintLeft
CheekSquintRight
NoseSneerLeft
NoseSneerRight
TongueOut
```

建议在 `InitDefaultCurveNames()` 中严格按该顺序初始化。

> Unreal 的 `FName` 比较通常不区分大小写，但数据集列名应统一采用 ACE 官方名称，避免后续跨软件或训练脚本中的命名混乱。

---

# 11. 加入图像采集

## 11.1 创建 Render Target

在 Content Browser：

```text
Add
→ Materials & Textures
→ Render Target
```

命名：

```text
RT_A2F_FaceCapture
```

建议参数：

```text
Size X = 512
Size Y = 512
Render Target Format = RTF RGBA8
Clear Color = Black
```
![示例图片](https://i.postimg.cc/76hLSvmv/79.png)
![示例图片](https://i.postimg.cc/DZ0z1V5t/80.png)

## 11.2 添加 SceneCaptureComponent2D

在 `BP_MyMH` 组件面板添加：

```text
SceneCaptureComponent2D
```

命名：

```text
FaceCapture
```

设置：

```text
Texture Target = RT_A2F_FaceCapture
Capture Source = Final Color (LDR) in RGB
Capture Every Frame = false
Capture On Movement = false
FOV Angle = 25～35
```

正式采集时必须保持：

```text
Capture Every Frame = false
Capture On Movement = false
```

由 C++ 在每个采样周期调用：

```cpp
SceneCapture->CaptureScene();
```

从而保证：

```text
CSV 第 N 行 ↔ frame_00000N.png
```

![示例图片](https://i.postimg.cc/qRq72fjd/81.png)
![示例图片](https://i.postimg.cc/26y5np2D/82.png)
![示例图片](https://i.postimg.cc/B6bv2WM3/83.png)


## 11.3 最终 BluePrint 连接方式如下图

![示例图片](https://i.postimg.cc/q7vC14KY/95.png)
![示例图片](https://i.postimg.cc/bvw2mpn4/95-1.png)
![示例图片](https://i.postimg.cc/DzwbxnGH/95-2.png)
![示例图片](https://i.postimg.cc/9fQqLC9k/95-3.png)
<!-- ![示例图片](https://i.postimg.cc/tTJgF02T/84.png)
![示例图片](https://i.postimg.cc/HxnLbGBk/85.png)
![示例图片](https://i.postimg.cc/HxNk2Sh2/91.png)
![示例图片](https://i.postimg.cc/pTSLZ06k/92-1.png)
![示例图片](https://i.postimg.cc/6qG51dkC/93.png)
![示例图片](https://i.postimg.cc/8crPnh2R/93-1.png)
![示例图片](https://i.postimg.cc/zvRXPnsn/94.png) -->

## 11.4 调整相机视角

打开 `BP_MyMH → Viewport`：

1. 选中 `FaceCapture`；
2. 移动到人物脸部正前方；
3. 调整旋转，使相机朝向脸部；
4. 调整 FOV；
5. 编译并保存。

调试期间可以临时开启：

```text
Capture Every Frame = true
Capture On Movement = true
```

然后打开 `RT_A2F_FaceCapture` 实时观察构图。

构图完成后必须关闭这两个选项。

![示例图片](https://i.postimg.cc/ydxN0qv3/86.png)
![示例图片](https://i.postimg.cc/zBQGjdcJ/87.png)
---

# 12. 调光方案

## 12.1 添加 Rect Light

回到主关卡：

```text
Window
→ Place Actors
→ Lights
→ Rect Light
```

将 Rect Light 放在Scene中的人物脸部前方。

建议：

- 灯光略高于眼睛；
- 朝向脸部；
- 避免过曝；
- 保证左右脸照明尽量均匀；
- 采集不同 Session 时保持灯光参数固定。

![示例图片](https://i.postimg.cc/0Q4yftBz/88.png)
![示例图片](https://i.postimg.cc/MTLpDsFb/89.png)
![示例图片](https://i.postimg.cc/nzWhkdPv/90.png)

## 12.2 验证图像

检查 Render Target 和输出 PNG：

- 不应是全黑图；
- 人脸应位于画面中心；
- 嘴部不能被裁切；
- 头部尺度应保持稳定；
- 不应存在明显曝光闪烁。

---

# 13. Recorder 蓝图执行流程

推荐蓝图结构：

```text
Event BeginPlay
    ↓
Set Face Mesh
    ↓
Set Scene Capture
    ↓
Enable Input
```

播放与录制：

```text
S Pressed
    ↓
Start Recording
    ↓
Create Audio2Face Parameters
    ↓
Set Parameters From Struct
    ↓
Animate Character From Wav File Async
```

Recorder 内部负责：

```text
读取 WAV 时长
    ↓
创建 Session
    ↓
复制输入 WAV
    ↓
写入 CSV 表头
    ↓
写入 metadata.json
    ↓
按 SampleFPS 定时采集
    ↓
WAV 时长 + NeutralDelay 后自动停止
```

---

# 14. Session 数据格式

推荐每次采集生成独立 Session：

```text
Saved/A2FDataset/
└── session_20260722_100503/
    ├── audio/
    │   └── input.wav
    ├── frames/
    │   ├── frame_000000.png
    │   ├── frame_000001.png
    │   └── ...
    ├── blendshapes.csv
    └── metadata.json
```

## 14.1 CSV 格式

表头：

```csv
sample_index,scheduled_time_sec,world_elapsed_sec,image_path,phase,EyeBlinkLeft,...,TongueOut
```

示例：

```csv
18,0.600000,0.645568,frames/frame_000018.png,audio,0.067020,...,0.000000
```

其中：

- `sample_index`：采样序号；
- `scheduled_time_sec`：理论采样时间；
- `world_elapsed_sec`：UE 世界实际经过时间；
- `image_path`：对应图片相对路径；
- `phase`：采集阶段；
- 后续 52 列：ACE ARKit 动画曲线值。

建议 `phase` 使用：

```text
audio
post_neutral
```

而不是简单使用 `speech/neutral`，因为 WAV 内部本身可能包含静音，Recorder 无法仅根据 WAV 时长判断实际是否正在讲话。

## 14.2 metadata.json

建议至少包含：

```json
{
  "session_id": "session_20260722_100503",
  "fps": 30,
  "audio_duration_sec": 5.217,
  "neutral_delay_sec": 1.0,
  "num_frames": 186,
  "blendshape_dim": 52,
  "image_width": 512,
  "image_height": 512,
  "capture_source": "SCS_FinalColorLDR",
  "a2f_provider": "LocalA2F-Claire"
}
```

开始录制时可写入初始版本，停止录制时再次覆盖，以更新最终：

```text
num_frames
recorded_duration_sec
```

---

# 15. 采集结果验证

一次有效 Session 应满足：

## 15.1 文件一致性

```text
CSV 数据行数 = PNG 图片数量
```

图片编号应连续：

```text
frame_000000.png
frame_000001.png
...
```

## 15.2 时间稳定性

30 FPS 理论间隔：

```text
1 / 30 ≈ 0.033333 秒
```

`scheduled_time_sec` 应按固定间隔递增。

`world_elapsed_sec` 允许存在少量抖动，但不应大范围跳变。

## 15.3 曲线有效性

开头或结尾出现连续全零帧可能是正常的准备阶段或后置 Neutral 阶段。

有效语音区间内应至少有部分曲线发生连续变化，例如：

```text
JawOpen
MouthClose
MouthFunnel
MouthPucker
MouthSmileLeft
MouthSmileRight
```

不能只检查 CSV 前几行就判断全部曲线为零。

## 15.4 图像有效性

检查：

- 图像不是全黑；
- 图片大小正确；
- 图像与 CSV 行数一致；
- 嘴部运动与曲线变化大致同步；
- 无明显掉帧或重复帧。

---

# 16. 常见问题

## 16.1 Build.cs 出现 `Unexpected character`

典型报错：

```text
Unexpected character '，'
Unexpected character '“'
```

原因是 C# 代码中混入中文标点。

错误：

```csharp
"Json"， “JsonUtilities”
```

正确：

```csharp
"Json",
"JsonUtilities"
```

## 16.2 `TEXT` 宏参数过多

错误：

```cpp
TEXT(
    "image_path",
    "phase"
)
```

正确：

```cpp
TEXT(
    "image_path,"
    "phase"
)
```

`TEXT()` 只能接收一个字符串参数。

## 16.3 `AppendCsvRow` 参数数量不匹配

函数声明：

```cpp
bool AppendCsvRow(
    int32 FrameIndex,
    double ScheduledTime,
    double WorldElapsedTime,
    const FString& RelativeImagePath,
    const FString& Phase,
    const TArray<float>& CurveValues
);
```

调用时必须传入 6 个参数：

```cpp
AppendCsvRow(
    PendingSampleIndex,
    PendingScheduledTime,
    PendingWorldElapsedTime,
    RelativeImagePath,
    PendingPhase,
    PendingCurveValues
);
```

## 16.4 `FImageUtils::CompressImageArray` 弃用警告

UE 5.6 可能提示：

```text
FImageUtils::CompressImageArray is deprecated
```

该警告通常不会阻止当前编译，但后续应迁移至新版 PNG 压缩接口。

## 16.5 图像为黑色

检查：

```text
RenderTarget 是否绑定
SceneCapture 是否绑定
Capture Source 是否正确
相机方向是否正确
灯光是否充足
CaptureScene() 是否被调用
```

## 16.6 CSV 曲线全部为零

依次检查：

```text
FaceMesh 是否绑定到 Face
Face AnimInstance 是否有效
Face_AnimBP 是否正在使用
Apply ACE Face Animations 是否连接
Pose Asset 是否使用 mh_arkit_mapping_pose_A2F
CurveNames 是否为 ACE 官方名称
音频是否已经开始驱动
```

---

# 17. 后续数据集构建建议

正式批量采集前，先使用少量 WAV 完成验证：

```text
10～50 条音频
```

检查：

- 每个 Session 都包含 WAV、CSV、PNG 和 metadata；
- CSV 曲线维度固定为 52；
- Session 间列顺序完全一致；
- 文件数量匹配；
- 无大量异常全零 Session；
- FPS 和图像参数保持一致。

完成小规模验证后，再进入批量采集阶段。

---

# 18. 参考资料

- NVIDIA ACE Unreal Plugin 官方文档；
- Epic Games MetaHuman 官方文档；
- 原始参考视频：[YouTube 视频](https://www.youtube.com/watch?v=-l8kjQUTfQk)。

> 视频教程适合辅助理解界面操作；插件安装、节点名称和版本兼容性应优先以 NVIDIA 与 Epic 官方文档为准。
