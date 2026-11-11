# 相机绑定流程

## 一、查看相机属性

### 1. 查看当前系统识别到的相机设备

插入 USB 相机后，执行以下命令查看当前系统识别到的相机设备：

```bash
v4l2-ctl --list-devices
```

可能会看到类似如下内容：

```bash
HD USB Camera: HD USB Camera (usb-0000:00:14.0-2):
    /dev/video0
    /dev/video1
```

或者：

```bash
XC-CAMERA: XC-CAMERA (usb-fc800000.usb-1):
    /dev/video0
    /dev/video1
    /dev/media0
```

其中，`/dev/video0`、`/dev/video1` 是系统动态分配的视频设备节点。该编号可能会因为设备拔插、USB 接口变化、多相机接入等情况发生改变，因此不建议在程序中直接固定使用：

```python
cv2.VideoCapture(0)
```

或直接固定使用：

```bash
/dev/video0
```

建议后续通过 udev 规则为相机创建固定软链接，例如：

```bash
/dev/camera_chest
```

---

### 2. 确认哪个设备节点对应目标相机

为了确认哪一个设备节点是目标相机，例如胸部相机，可以使用以下命令从指定相机采集一张图片。

以 `/dev/video0` 为例：

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=640,height=480,pixelformat=MJPG \
  --stream-mmap \
  --stream-to=/tmp/test.jpg \
  --stream-count=1
```

该命令会从 `/dev/video0` 采集一张图片，并保存到：

```bash
/tmp/test.jpg
```

查看采集到的图片：

```bash
timg /tmp/test.jpg
```

如果系统中没有 `timg`，可以手动安装：

```bash
sudo apt install timg
```

如果 `/dev/video0` 采集到的画面不是目标相机画面，可以继续测试其他节点，例如：

```bash
v4l2-ctl -d /dev/video1 \
  --set-fmt-video=width=640,height=480,pixelformat=MJPG \
  --stream-mmap \
  --stream-to=/tmp/test.jpg \
  --stream-count=1
```

---

### 3. 查看指定视频设备的详细属性

确认目标相机对应的 `/dev/videoX` 后，查看该设备的详细属性。

例如目标相机当前是 `/dev/video0`：

```bash
udevadm info --attribute-walk --name=/dev/video0
```

重点关注以下字段：

```bash
ATTR{name}
ATTR{index}
ATTRS{idVendor}
ATTRS{idProduct}
ATTRS{serial}
KERNELS
SUBSYSTEMS
```

例如某个相机可能具有如下属性：

```bash
ATTR{name}=="XC-CAMERA: XC-CAMERA"
ATTR{index}=="0"
ATTRS{idVendor}=="5843"
ATTRS{idProduct}=="7884"
ATTRS{serial}=="20250710"
```

其中：

- `ATTR{name}`：视频设备名称。
- `ATTR{index}`：视频节点索引。通常 `index=="0"` 对应真实视频流节点，`index=="1"` 可能是 metadata 或辅助节点。
- `ATTRS{idVendor}`：USB 设备厂商 ID。
- `ATTRS{idProduct}`：USB 设备产品 ID。
- `ATTRS{serial}`：设备序列号。如果相机具有唯一序列号，则可以用于稳定识别同一台相机。

---

### 4. 正确选择 `idVendor` 和 `idProduct`

在 `udevadm info --attribute-walk` 的输出中，可能会出现多组 `idVendor` 和 `idProduct`。绑定相机时，应选择**真正 USB 相机设备这一层**的 `idVendor`、`idProduct`，不要选择 USB HUB 或 Linux Host Controller 的字段。

典型设备层级如下：

```text
video4linux/video1
    ↓
USB interface: 4-1.1:1.0
    ↓
真正的相机设备: 4-1.1
    ↓
USB HUB: 4-1
    ↓
USB Host Controller: usb4
```

应该选择类似如下这一层：

```bash
looking at parent device '/devices/platform/fc880000.usb/usb4/4-1/4-1.1':
    KERNELS=="4-1.1"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{idVendor}=="5843"
    ATTRS{idProduct}=="7884"
    ATTRS{manufacturer}=="XC-TECH"
    ATTRS{product}=="XC-CAMERA"
    ATTRS{serial}=="SN00151"
```

即选择：

```bash
ATTRS{idVendor}=="5843"
ATTRS{idProduct}=="7884"
ATTRS{serial}=="SN00151"
```

不要选择类似如下 USB HUB 层的字段：

```bash
ATTRS{idVendor}=="1a86"
ATTRS{idProduct}=="8091"
ATTRS{product}=="USB HUB"
```

也不要选择类似如下 Host Controller 层的字段：

```bash
ATTRS{idVendor}=="1d6b"
ATTRS{idProduct}=="0002"
ATTRS{product}=="EHCI Host Controller"
```

判断原则：

```text
选择 ATTRS{product} 是相机名称的那一层；
不要选择 product 是 USB HUB 的那一层；
不要选择 product 是 EHCI/XHCI Host Controller 的那一层。
```

---

## 二、编写 udev 规则

### 1. 创建 udev 规则文件

创建 udev 规则文件：

```bash
sudo vim /etc/udev/rules.d/99-usb-camera.rules
```

如果系统中没有 `vim`，可以安装：

```bash
sudo apt install vim
```

也可以使用其他编辑器，例如：

```bash
sudo nano /etc/udev/rules.d/99-usb-camera.rules
```

---

### 2. 写入 udev 规则

写入如下规则内容：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250710", SYMLINK+="camera_chest", MODE="0666"
```

该规则的作用是：

- 只匹配 `video4linux` 类型的视频设备；
- 只匹配 `/dev/video*` 设备节点；
- 只匹配 `index=="0"` 的主视频流节点；
- 只匹配 `idVendor=="5843"`、`idProduct=="7884"`、`serial=="20250710"` 的指定相机；
- 为该相机创建固定软链接 `/dev/camera_chest`；
- 设置设备权限为 `0666`，使普通用户也可以访问该相机设备。

如果需要进一步限制相机名称，也可以使用更严格的规则：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{name}=="XC-CAMERA: XC-CAMERA", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250710", SYMLINK+="camera_chest", MODE="0666"
```

一般情况下，推荐优先使用较简洁的版本：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250710", SYMLINK+="camera_chest", MODE="0666"
```

如果当前相机的序列号是 `SN00151`，则规则应改为：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="SN00151", SYMLINK+="camera_chest", MODE="0666"
```

---

### 3. 重新加载 udev 规则

保存文件后，重新加载 udev 规则：

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

---

### 4. 重新识别相机设备

可以通过以下两种方式让规则生效：

方式一：拔掉相机并重新插入。

方式二：直接重启系统。

```bash
sudo reboot
```

系统启动时会重新枚举 USB 设备，并重新执行 udev 规则。

---

### 5. 检查固定设备链接是否生成

执行以下命令：

```bash
ls -l /dev/camera_chest
```

正常情况下可以看到类似结果：

```bash
/dev/camera_chest -> video0
```

或者：

```bash
/dev/camera_chest -> video2
```

这里的 `video0` 或 `video2` 可能会变化，但 `/dev/camera_chest` 是固定的。因此程序中应该使用 `/dev/camera_chest`，而不是直接使用 `/dev/video0` 或数字编号 `0`。

---

## 三、OpenCV 中的使用方式

### 1. 不推荐写法

原来的写法通常是：

```python
cap = cv2.VideoCapture(0)
```

这种写法依赖系统动态分配的 `/dev/videoX` 编号，不稳定。

---

### 2. 推荐写法

建议改为：

```python
cap = cv2.VideoCapture("/dev/camera_chest", cv2.CAP_V4L2)
```

完整示例：

```python
import cv2
import os

camera_path = "/dev/camera_chest"

if not os.path.exists(camera_path):
    raise RuntimeError(f"Camera device not found: {camera_path}")

cap = cv2.VideoCapture(camera_path, cv2.CAP_V4L2)

if not cap.isOpened():
    raise RuntimeError(f"Failed to open camera: {camera_path}")

ret, frame = cap.read()

if not ret or frame is None:
    raise RuntimeError("Camera opened, but failed to read frame")

print("Camera opened successfully")

cap.release()
```

---

## 四、取消绑定流程

如果后续不再需要该固定相机绑定，可以按以下步骤取消。

### 1. 删除相机 udev 规则文件

```bash
sudo rm /etc/udev/rules.d/99-usb-camera.rules
```

### 2. 重新加载 udev 规则

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 3. 清理残留软链接

```bash
sudo rm -f /dev/camera_chest
```

### 4. 再次检查

```bash
ls -l /dev/camera_chest
```

如果提示文件不存在，说明固定软链接已删除。

---

## 五、注意事项

### 1. 一个 USB 相机可能生成多个 `/dev/videoX`

很多 UVC 摄像头会同时生成多个视频节点，例如：

```bash
/dev/video0
/dev/video1
```

其中一个通常是真正的视频流节点，另一个可能是 metadata 节点或辅助节点。

因此在 `v4l2-ctl --list-devices` 中可能会看到：

```bash
HD USB Camera:
    /dev/video0
    /dev/video1
```

这时需要选择真正能够采集图像的那个节点。通常情况下，`ATTR{index}=="0"` 对应主视频流节点。

---

### 2. 验证哪个节点是真正的视频采集节点

可以分别查看设备信息：

```bash
v4l2-ctl --device=/dev/video0 --all
v4l2-ctl --device=/dev/video1 --all
```

也可以查看支持的图像格式和分辨率：

```bash
v4l2-ctl --device=/dev/video0 --list-formats-ext
v4l2-ctl --device=/dev/video1 --list-formats-ext
```

如果某个节点能够看到类似如下内容：

```bash
MJPG
YUYV
640x480
1280x720
```

说明该节点大概率是真正的视频采集节点。

---

### 3. 如果没有安装 `v4l2-ctl`

`v4l2-ctl` 属于 `v4l-utils` 工具包。如果系统中没有该命令，可以使用如下命令安装：

```bash
sudo apt install v4l-utils
```

---

### 4. 多台相机的情况

如果有多台相机，并且每台相机都有唯一的 `serial`，可以分别创建不同的固定软链接，例如：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250710", SYMLINK+="camera_chest", MODE="0666"

SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250711", SYMLINK+="camera_face", MODE="0666"
```

程序中分别使用：

```python
chest_cam = cv2.VideoCapture("/dev/camera_chest", cv2.CAP_V4L2)
face_cam = cv2.VideoCapture("/dev/camera_face", cv2.CAP_V4L2)
```

---

### 5. 如果相机没有唯一序列号

如果相机没有 `ATTRS{serial}`，则无法仅通过设备序列号稳定区分同型号相机。此时可以考虑使用 USB 物理端口路径进行绑定，例如通过 `KERNELS=="3-1"` 这类字段绑定固定 USB 接口。

但是这种方式绑定的是 USB 口，而不是相机本身。也就是说，相机换到其他 USB 口后，绑定关系可能会失效。

---

## 六、推荐结论

在程序中不建议使用：

```python
cap = cv2.VideoCapture(0)
```

推荐使用固定软链接：

```python
cap = cv2.VideoCapture("/dev/camera_chest", cv2.CAP_V4L2)
```

这样即使相机拔插后 `/dev/video0` 变成 `/dev/video2`，程序仍然可以通过 `/dev/camera_chest` 稳定访问同一台相机。

---

## 七、常见问题

### 1. `Invalid user/group` 或服务无法启动

检查 `/etc/systemd/system/face_main.service` 中的 `User=`、`WorkingDirectory=` 是否为真实用户与真实路径。

不要在普通服务中直接使用 `%i`、`%h` 这类模板服务占位符，除非你明确使用的是 systemd 模板服务。

---

### 2. `Device '/dev/camera_chest' is busy`

说明摄像头已被其他进程占用。可以先停止服务再测试：

```bash
sudo systemctl stop face_main.service
fuser /dev/camera_chest
```

如果需要查看具体占用进程，可以使用：

```bash
sudo fuser -v /dev/camera_chest
```

如需结束占用进程，请谨慎执行：

```bash
sudo fuser -k /dev/camera_chest
```

---

### 3. 符号链接未出现

如果 `/dev/camera_chest` 没有生成，可以按以下方向排查：

- 检查规则文件名是否以 `.rules` 结尾；
- 检查规则文件是否位于 `/etc/udev/rules.d/` 目录下；
- 核对 `ATTR{index}` 是否与 `udevadm info --attribute-walk` 输出一致；
- 核对 `ATTRS{idVendor}`、`ATTRS{idProduct}`、`ATTRS{serial}` 是否来自真正相机设备那一层；
- 执行以下命令查看规则是否匹配：

```bash
sudo udevadm test $(udevadm info -q path -n /dev/video0)
```

如果目标相机当前不是 `/dev/video0`，需要将命令中的 `/dev/video0` 替换为实际设备节点。

---

### 4. 打开了错误的摄像头

可以按以下方式排查：

- 确认 udev 规则里包含 `ATTR{index}=="0"`；
- 不要只用 `KERNEL=="video0"`，因为 `/dev/video0` 编号会变化；
- 多摄像头时，优先使用 `idVendor` + `idProduct` + `serial` 区分；
- 如果没有唯一 `serial`，再考虑通过 `KERNELS` 绑定 USB 物理端口。

---

### 5. 权限不足

如果程序没有权限访问相机，可以将运行用户加入 `video` 组。

以用户 `cat` 为例：

```bash
sudo usermod -aG video cat
```

重新登录后生效。

也可以在 udev 规则中设置合适的 `MODE` 或 `GROUP`，例如：

```bash
SUBSYSTEM=="video4linux", KERNEL=="video*", ATTR{index}=="0", ATTRS{idVendor}=="5843", ATTRS{idProduct}=="7884", ATTRS{serial}=="20250710", SYMLINK+="camera_chest", GROUP="video", MODE="0660"
```

如果使用 `GROUP="video", MODE="0660"`，需要确保运行程序的用户已经加入 `video` 组。

