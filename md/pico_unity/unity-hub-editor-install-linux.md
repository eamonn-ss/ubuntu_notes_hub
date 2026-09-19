# Unity Hub 与 Unity Editor 安装指导书（Ubuntu/Linux）

> 环境：Ubuntu/Linux + Unity Hub/Editor
> 验证：未复核（2026-09-19 仅做仓库整理，未在本机重跑步骤）
> 相关：[pico-teleop-robot-setup.md](pico-teleop-robot-setup.md)


## 1. 基本概念说明

在安装 Unity 前，需要先区分两个概念：

| 名称 | 作用 |
| --- | --- |
| Unity Hub | Unity 的版本管理器和项目管理器，用于登录账号、激活许可证、安装/管理 Unity Editor、创建/打开项目 |
| Unity Editor | 真正用于开发 Unity 项目的编辑器，例如 `Unity 2022.3.62f3` |

简单理解：

```text
Unity Hub = 管理器 / 启动器
Unity Editor = 真正写项目、搭场景、运行项目的软件
```

Unity 官方推荐在 Ubuntu 系发行版上通过 Unity Hub 仓库安装 Unity Hub，并通过 Unity Hub 管理不同版本的 Unity Editor。

参考链接：

```text
https://docs.unity.com/zh-cn/hub
```

---

## 2. 安装 Unity Hub

### 2.1 通过官方 APT 源安装 Unity Hub

在终端中执行以下命令：

```bash
sudo apt update
sudo apt install curl gpg -y

sudo install -d /etc/apt/keyrings

curl -fsSL https://hub.unity3d.com/linux/keys/public \
| sudo gpg --dearmor -o /etc/apt/keyrings/unityhub.gpg

sudo sh -c 'echo "deb [signed-by=/etc/apt/keyrings/unityhub.gpg] https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'

sudo apt update
sudo apt install unityhub -y
```

安装完成后，可以通过以下命令启动 Unity Hub：

```bash
unityhub
```

也可以在系统应用菜单中搜索：

```text
Unity Hub
```

然后点击启动。

---

### 2.2 安装 `.deb` 包时的提示说明

如果是通过 Unity Hub 的 `.deb` 安装包安装，过程中可能会出现如下提示：

```text
Add the Unity Hub package repository?
```

或者：

```text
Add the Unity Hub package repository? [y/N]
```

建议选择：

```text
Yes
```

或者在终端中输入：

```text
y
```

然后回车。

选择 `Yes` 后，系统会把 Unity Hub 的官方 APT 软件源加入系统。这样以后可以通过系统包管理器自动更新 Unity Hub：

```bash
sudo apt update
sudo apt upgrade
```

如果选择 `No`，Unity Hub 仍然可以安装，但后续不能通过 `apt upgrade` 自动更新。需要重新下载新版 `.deb` 包并手动安装。

手动更新 Unity Hub 的方式如下：

```bash
cd ~/Downloads
sudo apt install ./unityhub*.deb
```

如果使用 `dpkg` 安装：

```bash
sudo dpkg -i unityhub*.deb
sudo apt -f install
```

---

## 3. 登录 Unity Hub 并激活许可证

打开 Unity Hub 后，先登录 Unity 账号。

操作路径：

```text
Unity Hub 右上角头像
→ Sign in / 登录
→ 输入 Unity 账号和密码
→ 登录
```

登录完成后，进入许可证页面：

```text
Licenses / 许可证
→ Add license / 添加许可证
→ Get a free personal license
```

或者：

```text
Preferences / 设置
→ Licenses / 许可证
→ Add license / 添加许可证
→ Get a free personal license
```

选择：

```text
Unity Personal
```

然后点击同意协议并激活许可证。

激活成功后，在 `Licenses` 页面中应该可以看到：

```text
Unity Personal
```

注意：不要使用 `sudo unityhub` 启动 Unity Hub，也不要使用 root 用户启动 Unity Hub。否则许可证可能会写入 root 用户目录，普通用户启动 Unity Editor 时仍然可能提示没有许可证。

错误示例：

```bash
sudo unityhub
```

正确示例：

```bash
unityhub
```

Linux 下许可证文件通常位于：

```text
~/.local/share/unity3d/Unity/Unity_lic.ulf
```

可以用以下命令检查：

```bash
ls ~/.local/share/unity3d/Unity/
```

如果看到类似文件：

```text
Unity_lic.ulf
```

说明许可证已成功激活。

---

## 4. 安装 Unity Editor

Unity Editor 可以通过两种方式安装：

| 方式 | 说明 |
| --- | --- |
| Install Editor | 通过 Unity Hub 在线下载并安装 Unity Editor |
| Locate | 添加本地已经下载或解压好的 Unity Editor |

---

### 4.1 使用 Install Editor 在线安装

在 Unity Hub 中进入：

```text
Installs / 安装
→ Install Editor / 安装编辑器
```

在安装页面中，可以看到不同类型的版本：

| 分类 | 含义 | 建议 |
| --- | --- | --- |
| Official releases | 官方正式发布版 | 推荐使用 |
| Pre-releases | 预发布版，例如 Alpha、Beta | 不建议普通项目使用 |
| Archive | 历史归档版本 | 用于安装旧版本 Unity |

如果没有特殊要求，建议选择 LTS 长期支持版，例如：

```text
Unity 2022.3.x LTS
Unity 2021.3.x LTS
Unity 2020.3.x LTS
```

选择需要安装的 Unity Editor 版本后，点击：

```text
Install
```

安装过程中可以选择附加模块，例如：

```text
Android Build Support
WebGL Build Support
Linux Build Support
Windows Build Support
Documentation
Language packs
```

如果只是学习或普通 3D 项目开发，初始阶段可以只安装 Editor 本体。后续需要发布到 Android、WebGL 或其他平台时，再添加对应模块。

如果需要安装历史版本 Unity Editor，可以进入 Unity Editor Archive 页面：

[Unity Editor Archive](https://unity.com/releases/editor/archive)

在该页面中选择对应版本，例如 `2022.3.62f3`，然后可以通过 `Install` 调用 Unity Hub 安装，或者进入 `Manual installs` 下载 Linux 版本安装包。

---

### 4.2 使用 Locate 添加本地 Editor

如果已经手动下载并解压了 Unity Editor，例如：

```text
Unity-2022.3.62f3.tar.xz
```

可以先将其解压到推荐目录：

```bash
mkdir -p ~/Unity/Hub/Editor/2022.3.62f3

tar -xf ~/Unity-2022.3.62f3.tar.xz -C ~/Unity/Hub/Editor/2022.3.62f3
```

检查 Unity Editor 主程序是否存在：

```bash
ls ~/Unity/Hub/Editor/2022.3.62f3/Editor/Unity
```

如果路径存在，赋予可执行权限：

```bash
chmod +x ~/Unity/Hub/Editor/2022.3.62f3/Editor/Unity
```

然后在 Unity Hub 中进入：

```text
Installs / 安装
→ Locate / 定位
```

选择本地 Unity Editor 可执行文件：

```text
/home/用户名/Unity/Hub/Editor/2022.3.62f3/Editor/Unity
```

例如：

```text
/home/eamon/Unity/Hub/Editor/2022.3.62f3/Editor/Unity
```

添加成功后，在 `Installs` 页面中可以看到：

```text
Unity 2022.3.62f3 LTS
```

这说明 Unity Hub 已经成功识别该 Editor。

---

### 4.3 Install Editor 与 Locate 的区别

| 按钮 | 作用 | 是否下载 Editor |
| --- | --- | --- |
| Install Editor | 通过 Unity Hub 在线下载并安装新的 Unity Editor | 是 |
| Locate | 添加本地已经存在的 Unity Editor | 否 |

也就是说：

```text
Install Editor = 下载并安装新的 Unity Editor
Locate = 把本地已有 Editor 加入 Unity Hub 管理
```

如果已经下载并解压好了 Unity Editor，就使用 `Locate`。

如果还没有下载 Unity Editor，就使用 `Install Editor`。

---

### 4.4 Manage 的作用

在 `Installs` 页面中，每个 Unity Editor 版本右侧都有：

```text
Manage
```

该按钮用于管理当前 Editor。常见功能包括：

```text
Show in file manager / 打开文件所在位置
Add modules / 添加模块
Remove from Hub / 从 Hub 中移除
Uninstall / 卸载
```

如果 Unity Editor 是通过 Unity Hub 在线安装的，通常可以直接通过 `Manage` 添加模块。

如果 Unity Editor 是手动解压后通过 `Locate` 添加的，部分模块管理功能可能不完整。此时如果需要 Android、WebGL 等模块，可能需要单独下载对应版本的 Component Installer。

---

## 5. 创建 Unity 项目

安装并添加 Unity Editor 后，可以创建新项目。

进入 Unity Hub：

```text
Projects / 项目
→ New project / 新建项目
```

在新建项目页面，需要配置以下内容。

![alert text](https://i.postimg.cc/7YnYwhHf/1.png)

---

### 5.1 Editor version

```text
Editor version
```

表示该项目使用的 Unity Editor 版本。

例如：

```text
2022.3.62f3 LTS
```

如果系统中安装了多个 Unity Editor 版本，可以通过下拉框选择。

建议项目使用固定版本，不要频繁切换 Unity 版本。特别是复现别人项目时，应尽量安装与项目一致的 Unity Editor 版本。

![alert text](https://i.postimg.cc/0NF9cJfX/2.png)

---

### 5.2 模板分类

模板页面中可能出现以下分类：

| 分类 | 含义 |
| --- | --- |
| All | 显示所有模板 |
| Core | 核心空项目模板 |
| Learning | Unity 官方教学模板 |
| Sample | 示例项目 |
| Custom | 自定义模板 |

如果只是创建普通项目，建议选择：

```text
All
```

或者：

```text
Core
```

不建议一开始选择 `Learning`，因为 `Learning` 中多为官方教学项目，不是普通空项目。

---

### 5.3 常见项目模板说明

| 模板 | 含义 | 建议 |
| --- | --- | --- |
| 2D Built-In | 普通 2D 项目，使用内置渲染管线 | 做 2D 游戏或界面 |
| 3D Built-In | 普通 3D 项目，使用内置渲染管线 | 最稳定，推荐入门和普通项目 |
| Universal 2D | 使用 URP 的 2D 项目 | 需要 URP 2D 灯光等功能时使用 |
| Universal 3D | 使用 URP 的 3D 项目 | 移动端、跨平台、现代渲染项目 |
| High Definition 3D | 使用 HDRP 的高清 3D 项目 | 高画质项目，配置要求高，不推荐初学 |
| Microgame | Unity 官方教学项目 | 适合学习教程，不适合作为空项目 |

普通 3D 项目建议选择：

```text
3D (Built-In Render Pipeline)
```

该模板会创建一个普通 3D 项目，使用 Unity 传统的内置渲染管线，兼容性较好，适合学习、测试、机器人仿真、普通交互场景等。

---

### 5.4 View details

```text
View details
```

用于查看当前模板的详细信息。

通常包括：

```text
模板说明
使用的渲染管线
默认包含的资源
需要下载的内容
适用场景
```

该按钮只是查看说明，不是必须配置项。

---

### 5.5 Unity organization

```text
Unity organization
```

表示当前项目所属的 Unity 组织。

Unity 的许可证、云服务、团队协作、项目归属通常会挂在某个 Organization 下。个人账号默认也会有一个 Organization。

个人学习或本地开发时，一般保持默认即可。

只有在以下情况才需要修改：

```text
加入了公司或学校的 Unity 组织
需要使用团队许可证
需要将项目归属到指定团队
```

---

### 5.6 Project name

```text
Project name
```

表示项目名称。

不建议使用默认名称：

```text
My project
```

建议改成有意义的英文名称，例如：

```text
TestUnity2022
RobotDemo
FaceAvatarDemo
LipSyncDemo
MyFirst3DProject
```

项目命名建议：

```text
使用英文、数字、下划线
不要使用中文
不要使用空格
不要使用特殊符号
```

推荐示例：

```text
TestUnity2022
```

不推荐示例：

```text
我的项目
My project 1
Unity测试项目
```

---

### 5.7 Location

```text
Location
```

表示项目保存路径。

不建议直接保存在桌面或 home 根目录下，也不建议使用中文路径。

建议创建专门的 Unity 项目目录：

```bash
mkdir -p ~/UnityProjects
```

然后在 Unity Hub 中将 Location 设置为：

```text
/home/用户名/UnityProjects
```

例如：

```text
/home/eamon/UnityProjects
```

如果项目名称为：

```text
TestUnity2022
```

则最终项目路径为：

```text
/home/eamon/UnityProjects/TestUnity2022
```

这样方便统一管理、备份和迁移项目。

---

### 5.8 Source control provider

```text
Source control provider
```

这是源码管理选项，例如：

```text
Unity Version Control
Plastic SCM
```

如果只是本地测试、学习或普通开发，可以不选择，保持默认即可。

如果后续需要使用 Git，也可以在项目创建完成后手动初始化：

```bash
cd ~/UnityProjects/TestUnity2022
git init
```

---

### 5.9 Create project

```text
Create project
```

这是创建项目按钮。

当以下条件满足时可以点击：

```text
已选择 Unity Editor 版本
已选择项目模板
项目名称合法
Location 路径存在或可写
```

点击后，Unity Hub 会创建项目，并自动使用对应的 Unity Editor 打开项目。

---

## 6. 推荐的新项目配置

如果只是测试 Unity 是否安装成功，推荐如下配置：

```text
Editor version: 2022.3.62f3 LTS
Template: 3D (Built-In Render Pipeline)
Unity organization: 默认
Project name: TestUnity2022
Location: /home/eamon/UnityProjects
Source control provider: 不选
```

创建项目目录：

```bash
mkdir -p ~/UnityProjects
```

然后在 Unity Hub 中点击：

```text
Create project
```

等待 Unity Editor 打开。

---

## 7. Unity Editor 初始界面说明

成功打开项目后，会进入 Unity Editor 主界面。

常见区域如下：

| 区域 | 作用 |
| --- | --- |
| Hierarchy | 当前场景中的所有对象 |
| Scene | 场景编辑视图，用于摆放和编辑对象 |
| Game | 游戏运行视图，显示相机看到的画面 |
| Inspector | 检查器，用于查看和修改对象属性 |
| Project | 项目资源目录 |
| Console | 控制台，用于查看日志、警告和错误 |
| Toolbar | 运行、暂停、单帧调试等操作 |
| Menu Bar | 顶部菜单栏，包括 File、Edit、Assets、GameObject 等 |

---

![alert text](https://i.postimg.cc/sgffXz1s/3.png)
### 7.1 Hierarchy

```text
Hierarchy
```

显示当前场景中的所有对象。

默认 3D 项目通常包含：

```text
Main Camera
Directional Light
```

含义如下：

| 对象 | 作用 |
| --- | --- |
| Main Camera | 主相机，决定 Game 视图中看到的画面 |
| Directional Light | 方向光，类似太阳光，用于照亮场景 |

可以在 Hierarchy 中创建对象：

```text
Hierarchy 空白处右键
→ 3D Object
→ Cube
```

---

### 7.2 Scene

```text
Scene
```

用于编辑场景。

常用操作：

```text
右键 + WASD：移动视角
鼠标滚轮：缩放视图
Alt + 鼠标左键：旋转观察
F：聚焦到选中的对象
```

左侧工具栏常用快捷键：

| 快捷键 | 工具 | 作用 |
| --- | --- | --- |
| Q | Hand Tool | 移动观察视角 |
| W | Move Tool | 移动对象 |
| E | Rotate Tool | 旋转对象 |
| R | Scale Tool | 缩放对象 |
| T | Rect Tool | UI/2D 矩形工具 |

---

### 7.3 Game

```text
Game
```

显示游戏运行时玩家看到的画面。

区别：

```text
Scene = 开发者编辑视角
Game = 玩家最终看到的画面
```

Game 视图中的内容来自 `Main Camera`。

---

### 7.4 Inspector

```text
Inspector
```

用于查看和修改选中对象的属性。

例如选中 `Main Camera` 后，可以看到：

```text
Transform
Camera
Audio Listener
```

选中 `Directional Light` 后，可以看到：

```text
Transform
Light
```

常见可修改内容包括：

```text
Position / 位置
Rotation / 旋转
Scale / 缩放
Camera 参数
Light 参数
Material 材质
Script 脚本参数
```

---

### 7.5 Project

```text
Project
```

显示项目资源文件。

常见目录：

```text
Assets
Packages
```

其中：

```text
Assets
```

是项目自己的资源目录，脚本、场景、模型、图片、材质等通常都放在这里。

例如创建 C# 脚本：

```text
Project 面板空白处右键
→ Create
→ C# Script
```

---

### 7.6 Console

```text
Console
```

用于查看日志、警告和错误。

常见内容包括：

```text
Debug.Log 输出
Warning 警告
Error 错误
脚本编译错误
运行时异常
```

如果 Unity 项目报错，优先查看 `Console` 面板。

---

### 7.7 Toolbar

顶部中间的按钮：

```text
Play
Pause
Step
```

含义如下：

| 按钮 | 作用 |
| --- | --- |
| Play | 运行当前场景 |
| Pause | 暂停运行 |
| Step | 单帧运行 |

注意：在 Play Mode 中修改的场景内容，退出运行后通常不会保存。因此正式修改场景时，应退出 Play Mode 后再修改。

---

## 8. 最小测试流程

为了验证 Unity 是否安装成功，可以创建一个简单 Cube 测试。

### 8.1 创建 Cube

在 Hierarchy 面板中：

```text
右键
→ 3D Object
→ Cube
```

场景中会出现一个立方体。

---

### 8.2 选中 Cube

在 Hierarchy 中点击：

```text
Cube
```

右侧 Inspector 会显示 Cube 的属性。

可以修改：

```text
Transform → Position
Transform → Rotation
Transform → Scale
```

---

### 8.3 运行场景

点击顶部：

```text
Play
```

如果在 Game 视图中可以看到 Cube，说明 Unity Editor 可以正常运行。

---

## 9. 常见问题

### 9.1 直接双击 Unity Editor 报 License error

如果直接双击：

```text
Editor/Unity
```

可能会出现：

```text
License error
No valid Unity Editor license found.
```

解决方法：

```text
先打开 Unity Hub
登录 Unity 账号
激活 Unity Personal 许可证
通过 Unity Hub 启动 Unity Editor
```

不要直接使用 root 权限运行 Unity。

---

### 9.2 Unity Hub 点击历史版本 Install 没反应

在 Linux 中，Unity 历史版本网页的 `Install` 按钮通常会调用：

```text
unityhub://
```

如果浏览器弹出：

```text
要打开 xdg-open 吗？
```

但点击后没反应，通常是 `unityhub://` 协议没有正确关联到 Unity Hub。

可以检查：

```bash
xdg-mime query default x-scheme-handler/unityhub
```

如果没有输出，可以尝试：

```bash
xdg-mime default unityhub.desktop x-scheme-handler/unityhub
sudo update-desktop-database /usr/share/applications
```

如果仍然无法跳转，建议使用手动下载 Unity Editor 压缩包的方式，然后通过 Unity Hub 的 `Locate` 添加。

---

### 9.3 不建议使用中文路径

Unity 项目路径、资源路径、脚本路径建议使用英文。

推荐路径：

```text
/home/eamon/UnityProjects/TestUnity2022
```

不推荐路径：

```text
/home/eamon/桌面/Unity测试项目
```

原因是部分插件、构建工具、脚本或第三方库可能对中文路径支持不稳定。

---

### 9.4 不建议使用空格路径

不推荐：

```text
My project
```

推荐：

```text
MyProject
My_Project
TestUnity2022
```

空格路径在部分命令行工具、脚本或构建流程中可能带来额外问题。

---

## 10. 总结流程

完整安装和使用流程如下：

```text
安装 Unity Hub
→ 登录 Unity 账号
→ 激活 Unity Personal 许可证
→ 安装 Unity Editor 或 Locate 本地 Editor
→ 创建 Unity 项目
→ 选择模板
→ 设置项目名称和保存路径
→ Create project
→ 进入 Unity Editor
→ 创建 Cube 测试运行
```

推荐初始配置：

```text
Unity Hub: 使用官方 APT 源安装
Unity Editor: 2022.3.x LTS
Template: 3D (Built-In Render Pipeline)
Project name: 英文命名
Location: ~/UnityProjects
Source control provider: 默认不选
```
