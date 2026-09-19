# UE FACEGOOD → MetaHuman 数据采集环境搭建与验证文档

> 环境：UE 5.6 + FACEGOOD Audio2Face → MetaHuman 采集
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[ace-unreal-a2f-metahuman-data-capture.md](ace-unreal-a2f-metahuman-data-capture.md)


## 1. 文档目的

本文用于记录并复现一套已经验证通过的 **FACEGOOD Audio2Face → Unreal Engine 5.6 → MetaHuman → Dataset Capture** 工程流程。

目标是在一个全新的 UE 工程中，按照固定步骤重新搭建并验证：

```text
Linux FACEGOOD
    ↓
Audio2Face inference
    ↓
RAW37
    ↓
ARKit52
    ↓
FGDS / TCP
    ↓
UE5 Receiver
    ↓
Live Link
    ↓
MetaHuman
    ↓
SceneCapture2D
    ↓
PNG + BlendShape Dataset
```

本文按以下结构组织：

1. 框架说明
2. 基础实现步骤
3. 测试步骤
4. 常见问题与排查
5. 最终验证结果
6. 重建 Checklist

---

# 2. 系统框架说明

## 2.1 Linux 侧流程

Linux 侧负责：

```text
WAV
↓
FACEGOOD inference
↓
RAW37
↓
ARKit52
↓
FGDS packet
↓
TCP
↓
Windows UE
```

Dataset 模式下，Linux 还负责创建 Session 及标签文件：

```text
Session
├── metadata.json
├── blendshapes.csv
└── Session 生命周期
```

并采用严格的 Stop-and-Wait：

```text
FRAME N
→ ACK N
→ FRAME N+1
```

## 2.2 Windows / UE 侧流程

主要组件：

```text
FaceGoodTcpReceiver
→ TCP / FGDS 协议解析

FaceGoodTestLiveLink
→ ARKit52 → MetaHuman Live Link

FaceGoodSynchronizedPlayback
→ Preview 音频与动画同步

FaceGoodDatasetRecorder
→ Apply
→ Render Wait
→ Capture
→ Save
→ ACK
```

Dataset 完整流程：

```text
SESSION_START
↓
UE Dataset Preflight
↓
SESSION_READY
↓
FRAME 0
↓
Live Link Apply
↓
MetaHuman Render
↓
SceneCapture2D
↓
PNG Save
↓
ACK 0
↓
...
↓
SESSION_COMPLETE
↓
SESSION_COMPLETE_ACK
```

## 2.3 数据对齐原则

整个 Dataset 中唯一可信的对齐基准是：

```text
frame_id
```

即：

```text
frame_id = N
```

对应：

```text
blendshapes.csv
→ 第 N 帧 ARKit52

frames/000NNN.png
→ 第 N 帧 MetaHuman 图像

audio time
→ N / 30 秒
```

不要使用 TCP 到达时间、UE Tick 时间或 PNG 保存时间作为标签对齐依据。

---

# 3. 基础实现步骤

## 3.1 创建 UE C++ 项目

打开 Unreal Engine 5.6，创建：

```text
Template: Blank
Project Type: C++
Project Name: FG
```

建议路径：

```text
D:\UnrealProjects\FG
```

进入项目后，新建或选择一个 Level，并保存。

![alter text](https://i.postimg.cc/RF7C0rJV/1.png)
![alter text](https://i.postimg.cc/SQGNFhh4/2.png)
![alter text](https://i.postimg.cc/y6TY4Hzr/3.png)
![alter text](https://i.postimg.cc/yx71gf0t/4.png)

## 3.2 启用 MetaHuman 相关插件

进入：

```text
Edit
→ Plugins
```

启用 MetaHuman 相关插件，完成后重启 UE。

![alter text](https://i.postimg.cc/MKP6HmHD/5.png)

## 3.3 创建 MetaHuman

在 Content Browser：

```text
右键
→ MetaHuman
→ MetaHuman Character
```

创建：

```text
MyMH
```

双击进入配置界面，完成人物配置。

![alter text](https://i.postimg.cc/NjKgH2rw/6.png)
![alter text](https://i.postimg.cc/zvdrLqzN/7.png)
![alter text](https://i.postimg.cc/7Lgr33Hd/8.png)

## 3.4 将 MetaHuman 放入场景

进入：

```text
Content
→ MyMH
```

将：

```text
BP_MyMH
```

拖入 Level。

建议将：

```text
BP_MyMH
→ Transform
→ Location
```

设置为：

```text
X = 0
Y = 0
Z = 0
```

如果与 `PlayerStart` 重叠，则移动 `PlayerStart`。

![alter text](https://i.postimg.cc/NMDhVQrP/9.png)
![alter text](https://i.postimg.cc/0jXTkZnW/10.png)

## 3.5 迁移 FACEGOOD C++ 源码

将已验证通过的 FACEGOOD C++ 源码复制到：

```text
D:\UnrealProjects\FG\Source\FG\
```

主要包括：

```text
FG.Build.cs
FaceGoodTcpReceiverComponent.h
FaceGoodTcpReceiverComponent.cpp
FaceGoodTestLiveLinkComponent.h
FaceGoodTestLiveLinkComponent.cpp
FaceGoodDatasetRecorder.h
FaceGoodDatasetRecorder.cpp
FaceGoodSynchronizedPlayback.h
FaceGoodSynchronizedPlayback.cpp
```

## 3.6 修改 Module / API Macro

原工程如果使用：

```text
A2F_FG
```

新工程为：

```text
FG
```

重点检查：

```text
FG.Build.cs
FaceGoodTcpReceiverComponent.h
FaceGoodTestLiveLinkComponent.h
FaceGoodDatasetRecorder.h
FaceGoodSynchronizedPlayback.h
```

例如：

```cpp
A2F_FG_API
```

替换为：

```cpp
FG_API
```

同时检查：

```text
Module Name
API Macro
Include
Dependency
```

是否一致。

## 3.7 编译 C++ 项目

关闭 UE Editor，使用 Visual Studio 打开：

```text
FG.sln
```

编译：

```text
Development Editor
Win64
FG
```

确认：

```text
Build succeeded
```

---

# 4. 创建 FACEGOOD 控制 Actor

在 Level 中创建普通 Actor，例如：

```text
Actor2
```

添加组件：

```text
Audio
FaceGoodTcpReceiver
FaceGoodTestLiveLink
FaceGoodDatasetRecorder
FaceGoodSynchronizedPlayback
```

建议结构：

```text
Actor2
├── DefaultSceneRoot
├── Audio
├── FaceGoodTcpReceiver
├── FaceGoodTestLiveLink
├── FaceGoodDatasetRecorder
└── FaceGoodSynchronizedPlayback
```

![alter text](https://i.postimg.cc/ryhXNFTy/11.png)
![alter text](https://i.postimg.cc/769vcqTS/12.png)

![alter text](https://i.postimg.cc/Pf6sQrHT/14.png)
![alter text](https://i.postimg.cc/tCY0SQRZ/15.png)
![alter text](https://i.postimg.cc/VNP3kJ9Q/16.png)


![alter text](https://i.postimg.cc/JzVTb9sc/23.png)

---

# 5. Live Link 配置

在 Dataset 设置为 Preview 模式下，并执行PIE中。

打开：

```text
BP_MyMH
```

找到 Live Link Subject 配置，设置：

```text
FaceGoodTest
```

名称必须完全一致。

![alter text](https://i.postimg.cc/BvJMzH5m/24.png)
![alter text](https://i.postimg.cc/q7pjFyXd/25.png)

---

# 6. Preview Mode 配置

## 6.1 FaceGoodTcpReceiver

```text
Actor2
→ FaceGoodTcpReceiver
```

配置：

```text
Listen Port = 7001
Runtime Mode = Preview
```

## 6.2 Animation Only

```text
Actor2
→ FaceGoodSynchronizedPlayback
```

配置：

```text
Playback Mode = Animation Only
Playback FPS = 30
Prebuffer Frames = 3
Expected Frame Count = 366
```

## 6.3 Audio + Animation Sync

导入：

```text
zisumei.wav
```

配置：

```text
Playback Mode = Synchronized Audio Animation
Playback FPS = 30
Prebuffer Frames = 3
Expected Frame Count = 366
Auto Start when Ready = true
Audio Source = zisumei
```

`Audio Component` 可以保持：

```text
None
```

当前实现会自动查找 Actor2 上的 `AudioComponent`，但 Actor2 中的 `Audio` 组件仍需保留。

![alter text](https://i.postimg.cc/GtgWLzKh/13.png)

---

# 7. Dataset Capture 配置

## 7.1 创建 Render Target

在 Content Browser：

```text
右键
→ Materials & Textures
→ Render Target
```

命名：

```text
RT_FaceGood_Dataset
```

建议分辨率：

```text
512 × 512
```
![alter text](https://i.postimg.cc/mkkn5C4P/17.png)
![alter text](https://i.postimg.cc/j21102qM/18.png)

## 7.2 创建 SceneCapture2D

从Place Actor 中添加 Scene Capture 2D 并 加入 Level 中。

在 Level 中加入独立：

```text
Scene Capture 2D
```

命名：

```text
FaceGoodDatasetCapture
```

建议结构：

```text
Level
├── BP_MyMH
├── Actor2
└── FaceGoodDatasetCapture
```

![alter text](https://i.postimg.cc/GhBNPFzM/19.png)

## 7.3 SceneCaptureComponent2D 配置

选择：

```text
FaceGoodDatasetCapture
```

配置：

```text
Texture Target = RT_FaceGood_Dataset
Capture Every Frame = false
Capture On Movement = false
Always Persist Rendering State = true
```

建议：

```text
FOV = 25
```

相机位置需保证能够完整看到 MetaHuman 面部。

![alter text](https://i.postimg.cc/kgKpz70F/20.png)
![alter text](https://i.postimg.cc/sXDHM7v0/21.png)
![alter text](https://i.postimg.cc/Wzx5YySn/22.png)

## 7.4 FaceGoodDatasetRecorder 配置

选择：

```text
Actor2
→ FaceGoodDatasetRecorder
```

配置：

```text
Render Wait Ticks = 1
```

例如：

```text
Dataset Root Directory
= D:\FaceGoodDataset\run_001
```

最关键：

```text
Dataset Capture Actor
= FaceGoodDatasetCapture
```

这一项属于关卡实例引用，复制 C++ 源码后不会自动恢复。

如果：

```text
Dataset Capture Actor = None
```

则 Dataset Preflight 会失败。

![alter text](https://i.postimg.cc/MGtdJHdX/26.png)

## 7.5 Dataset Receiver 配置

```text
Actor2
→ FaceGoodTcpReceiver
```

Dataset 模式设置：

```text
Runtime Mode = Dataset
```

## 7.6 Light 配置

选择：

```text
Place Actor
→ Rect Light
```

![alter text](https://i.postimg.cc/vBBXYyNJ/27.png)

---

# 8. Dataset 配置关系

```text
Actor2
│
├── FaceGoodTcpReceiver
│       Runtime Mode = Dataset
│
├── FaceGoodTestLiveLink
│
└── FaceGoodDatasetRecorder
        │
        ├── Render Wait Ticks = 1
        ├── Dataset Root Directory
        └── Dataset Capture Actor
                 │
                 ▼
        FaceGoodDatasetCapture
                 │
                 ▼
        SceneCaptureComponent2D
                 │
                 ▼
        RT_FaceGood_Dataset
```
---

# 9. Linux / Windows 共享目录

Windows：

```text
D:\FaceGoodDataset
```

共享目录：

```text
\\10.7.5.134\FaceGoodDataset
```

Linux 挂载：

```text
/mnt/facegood-dataset
```

例如：

Windows：

```text
D:\FaceGoodDataset\run_007
```

Linux：

```text
/mnt/facegood-dataset/run_007
```

两端必须指向同一个共享目录。

假设：

Windows IP = 10.7.5.134
共享名      = FaceGoodDataset
Linux mount = /mnt/facegood-dataset

```bash
# 先安装 CIFS：

sudo apt update
sudo apt install cifs-utils

# 建立挂载点：

sudo mkdir -p /mnt/facegood-dataset

# 然后先临时测试挂载。

# 如果 Windows 共享使用用户名/密码：

sudo mount -t cifs //10.7.5.134/FaceGoodDataset \
  /mnt/facegood-dataset \
  -o username=<你的Windows用户名>,uid=$(id -u),gid=$(id -g),file_mode=0664,dir_mode=0775

# 它会提示输入 Windows 密码。

# 注意这里：
# uid=$(id -u)
# gid=$(id -g)
# 非常重要。否则 CIFS 挂载后的文件可能都显示成：root:root 你的用户仍然不能正常写。
# 挂载后检查：

findmnt -T /mnt/facegood-dataset

# 然后：

touch /mnt/facegood-dataset/linux_test.txt
ls -l /mnt/facegood-dataset/linux_test.txt

# 如果成功，再去 Windows： D:\FaceGoodDataset
# 确认能看到：linux_test.txt，如果能看到，那么共享目录真正打通了。

# 如果重新创建了 Windows Share，Linux 最好重新挂载一次，因为当前 CIFS connection 是建立在旧共享上的。

# 先：

sudo umount /mnt/facegood-dataset

# 然后：

sudo mount -t cifs //10.7.5.134/FaceGoodDataset \
  /mnt/facegood-dataset \
  -o username=<你的Windows用户名>,uid=$(id -u),gid=$(id -g),vers=3.0,file_mode=0664,dir_mode=0775

```

![alter text](https://i.postimg.cc/pr2JyHr5/28.png)

---

# 10. 测试步骤

## 10.1 测试 1：Live Link / Manual jawOpen

目标：

```text
确认 MetaHuman 已接入 FaceGoodTest Live Link
```

检查：

```text
Live Link Subject = FaceGoodTest
```

确认 jawOpen 测试时人物嘴部有明显变化。

测试通过后，将 `use test jaw open` 置为 `false`, dataset 模式置为 `dataset`。
![alter text](https://i.postimg.cc/Qxdq3hvw/29.png)
![alter text](https://i.postimg.cc/8PzbSNxx/30.png)

## 10.2 测试 2：TCP Preview Animation Only

Linux：

```bash
cd ~/code/QB-Audio2Face/code/test/AiSpeech
```

执行：

```bash
python send_metahuman_sequence_tcp.py \
  --artifact output/zisumei \
  --host 10.7.5.134 \
  --port 7001 \
  --fps 30
```

预期：

```text
sent_frames = 366
frame_id = 0 ~ 365
```

UE 应看到：

```text
Client connected
```

MetaHuman 唇部正常变化。

![alter text](https://i.postimg.cc/FsHx4N2Q/31.png)
![alter text](https://i.postimg.cc/sDgJrstC/32.png)

## 10.3 测试 3：Audio + Animation Sync

UE：

```text
Runtime Mode = Preview
Playback Mode = Synchronized Audio Animation
Audio Source = zisumei
Auto Start when Ready = true
```

Linux 仍执行：

```bash
python send_metahuman_sequence_tcp.py \
  --artifact output/zisumei \
  --host 10.7.5.134 \
  --port 7001 \
  --fps 30
```

预期：

```text
MetaHuman 唇部运动
+
音频正常播放
+
整体同步稳定
```

![alter text](https://i.postimg.cc/m2pyZKsz/33.png)


## 10.4 测试 4：单 WAV Dataset Capture

建立单 WAV 输入目录：

```bash
cd ~/code/QB-Audio2Face/code/test/AiSpeech

mkdir -p res/rebuild_single
cp res/zisumei.wav res/rebuild_single/
```

确认：

```bash
ls -lh res/rebuild_single
```

目录中只保留：

```text
zisumei.wav
```

UE：

```text
FaceGoodTcpReceiver
→ Runtime Mode = Dataset
```

```text
FaceGoodDatasetRecorder
→ Dataset Root Directory = D:\FaceGoodDataset\run_007
→ Render Wait Ticks = 1
→ Dataset Capture Actor = FaceGoodDatasetCapture
```

```text
FaceGoodDatasetCapture
→ Texture Target = RT_FaceGood_Dataset
→ Capture Every Frame = false
→ Capture On Movement = false
```

启动 PIE。

Linux：

```bash
python collect_dataset_batch.py \
  --input-dir res/rebuild_single \
  --output-dir /mnt/facegood-dataset/run_007 \
  --host 10.7.5.134 \
  --port 7001 \
  --on-error stop \
  --mapping-mode audited \
  --raw27-test-mode 1015-direct \
  --capture-width 512 \
  --capture-height 512 \
  --render-wait-ticks 1 \
  --camera-actor FaceGoodDatasetCapture \
  --render-target RT_FaceGood_Dataset \
  --camera-fov 25 \
  --ue-version 5.6.1
```

![alter text](https://i.postimg.cc/T3yqKQ28/34.png)
![alter text](https://i.postimg.cc/rwvGxWz8/35.png)

## 10.5 Dataset 预期结果

Linux 最终类似：

```text
Batch Summary
-------------
sessions       : 1
completed      : 1
failed         : 0
total frames   : 366

RESULT: PASS
```

Windows 产生：

```text
D:\FaceGoodDataset\run_007\
└── session_..._zisumei\
    ├── metadata.json
    ├── blendshapes.csv
    └── frames\
        ├── 000000.png
        ├── 000001.png
        ├── ...
        └── 000365.png
```

---

# 11. 常见问题与排查

## 11.1 TCP 已连接，但 MetaHuman 不动

检查：

```text
Live Link Subject = FaceGoodTest
```

以及当前 `Runtime Mode` 是否正确。

## 11.2 Animation Only 正常，但音频不同步或不启动

检查：

```text
Audio Source = zisumei
Playback Mode = Synchronized Audio Animation
```

## 11.3 Audio Component = None 是否错误

不是。

当前实现允许：

```text
Audio Component = None
```

运行时会自动查找 Actor2 中的：

```text
Audio
```

但 `Audio Source` 仍必须设置。

## 11.4 Dataset 报错：A new FRAME is forbidden while another frame is active

通常说明：

```text
发送端没有正确进入 Session 流程
```

或 Recorder 当前不是：

```text
WaitingForFrame
```

最终 Dataset 采集应使用：

```text
collect_dataset_batch.py
```

## 11.5 Dataset 报错：Dataset preflight failed

依次检查：

```text
Runtime Mode == Dataset
Dataset Capture Actor != None
SceneCaptureComponent2D != None
Texture Target != None
Capture Every Frame == false
Render Wait Ticks >= 1
```

其中 clean rebuild 最容易漏掉：

```text
FaceGoodDatasetRecorder
→ Dataset Capture Actor
→ FaceGoodDatasetCapture
```

## 11.6 Dataset Capture Actor = None

这是本次 clean rebuild 实际遇到的问题。

表现：

```text
failure=11
Dataset preflight failed
```

原因：

```text
FaceGoodDatasetRecorder
→ Dataset Capture Actor
```

没有绑定。

修复：

```text
Dataset Capture Actor
= FaceGoodDatasetCapture
```

重新测试后 Dataset Capture 成功。

---

# 12. 最终结果

当前新工程从零重建已经验证：

```text
UE Project                     PASS
MetaHuman                      PASS
FaceGoodTest Live Link         PASS
Manual jawOpen                 PASS
Linux → UE TCP                 PASS
Animation Only Preview         PASS
Audio + Animation Sync         PASS
Dataset Session                PASS
SceneCapture PNG               PASS
```

说明：

```text
FACEGOOD
→ ARKit52
→ FGDS/TCP
→ UE5
→ Live Link
→ MetaHuman
→ SceneCapture2D
→ PNG Dataset
```

可以在新的 Unreal Engine 5.6 C++ 项目中重新搭建并运行。

---

# 13. 重建 Checklist

## 13.1 工程

- [ ] UE 5.6 C++ 项目创建成功
- [ ] Project Name = `FG`
- [ ] Level 已保存
- [ ] MetaHuman 插件已启用
- [ ] 项目重启完成

## 13.2 MetaHuman

- [ ] `MyMH` 创建成功
- [ ] `BP_MyMH` 已加入 Level
- [ ] Transform 已调整
- [ ] PlayerStart 未阻挡角色

## 13.3 C++

- [ ] FACEGOOD C++ 源码复制完成
- [ ] `FG.Build.cs` 正确
- [ ] `A2F_FG_API` 已替换为 `FG_API`
- [ ] Module Name 已清理
- [ ] Visual Studio Build PASS

## 13.4 Actor2

- [ ] Audio
- [ ] FaceGoodTcpReceiver
- [ ] FaceGoodTestLiveLink
- [ ] FaceGoodDatasetRecorder
- [ ] FaceGoodSynchronizedPlayback

## 13.5 Live Link

- [ ] Live Link Subject = `FaceGoodTest`
- [ ] UE Log 出现 LiveLink source registered

## 13.6 TCP

- [ ] Port = 7001
- [ ] Windows IP 正确
- [ ] Linux 可以连接 Windows
- [ ] UE Log 出现 Client connected

## 13.7 Preview

- [ ] Runtime Mode = Preview
- [ ] Animation Only 正常
- [ ] Playback FPS = 30
- [ ] Expected Frame Count = 366
- [ ] Prebuffer Frames = 3

## 13.8 Audio Sync

- [ ] Actor2 中存在 Audio
- [ ] `zisumei.wav` 已导入
- [ ] Audio Source = `zisumei`
- [ ] Playback Mode = Synchronized Audio Animation
- [ ] Auto Start when Ready = true
- [ ] Audio 正常
- [ ] MetaHuman 唇部同步

## 13.9 Render Target

- [ ] `RT_FaceGood_Dataset` 已创建
- [ ] Resolution = 512×512

## 13.10 SceneCapture

- [ ] `FaceGoodDatasetCapture` 已加入 Level
- [ ] Texture Target = `RT_FaceGood_Dataset`
- [ ] Capture Every Frame = false
- [ ] Capture On Movement = false
- [ ] Always Persist Rendering State = true
- [ ] FOV 正确
- [ ] 相机可以看到人物面部

## 13.11 Dataset Recorder

- [ ] Render Wait Ticks = 1
- [ ] Dataset Root Directory 正确
- [ ] Dataset Capture Actor = FaceGoodDatasetCapture

## 13.12 Dataset Mode

- [ ] Runtime Mode = Dataset
- [ ] Windows / Linux 共享目录一致
- [ ] metadata.json 可见
- [ ] blendshapes.csv 可见
- [ ] session frames 目录为空
- [ ] PNG 正常生成
- [ ] PNG 非黑图
- [ ] frame_id 连续
- [ ] ACK 连续
- [ ] gaps = 0
- [ ] errors = 0
