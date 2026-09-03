# 安装nvidia-container-toolkit

## [官方教程链接](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## nvidia-container-toolkit 是什么？

NVIDIA Container Toolkit 使用户能够构建和运行 GPU 加速容器。该工具包包括一个容器运行时库和实用程序，用于自动配置容器以利用 NVIDIA GPU。

## 安装nvidia-container-toolkit

1. 需要先安装好docker和nvidia驱动

2. 配置存储库
- 这是nvidia官方配置对于ubuntu：
    ```
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    ```
- 由于官网的放在github上，访问很慢所以这里使用国内的存储库，中科大的。
    ```
    curl -fsSL https://mirrors.ustc.edu.cn/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://mirrors.ustc.edu.cn/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://nvidia.github.io#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://mirrors.ustc.edu.cn#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    ```

3. 更新软件包列表
    ```sudo apt-get update```

4. 安装nvidia-container-toolkit
   ```sudo apt-get install -y nvidia-container-toolkit```
5. 验证安装
   ```nvidia-container-cli  --version```

## 配置 NVIDIA 容器工具包（NVIDIA Container Toolkit）以便 Docker 使用 NVIDIA GPU

1. 配置docker:
   ```sudo nvidia-ctk runtime configure --runtime=docker```

   ```
   nvidia-ctk：是 NVIDIA Container Toolkit 的命令行工具。它用于配置和管理 NVIDIA 的容器运行时，特别是与 Docker、Kubernetes 等容器管理工具配合使用时，确保容器能够访问 GPU 资源。

    runtime configure：这个命令用于配置 NVIDIA 容器运行时，允许你设置一些关键的参数和选项。通过它，你可以指定容器运行时，例如 Docker，来使用 NVIDIA GPU。

    --runtime=docker：这表示配置 Docker 作为容器运行时。即，告诉 NVIDIA 容器工具包将 Docker 容器配置为支持 GPU 的容器运行时。

    sudo：此命令需要管理员权限，因此使用 sudo 来确保能够修改系统配置。
   ```
   使用 nvidia-ctk 命令配置容器运行时：该命令用于配置 Docker 以使用 NVIDIA 容器运行时。具体来说，它会修改 /etc/docker/daemon.json 文件，将 NVIDIA 容器运行时设置为 Docker 的默认运行时
    配置 Docker 使用 NVIDIA 容器运行时：这允许 Docker 容器访问和利用 NVIDIA GPU 资源，从而支持 GPU 加速。
    修改 /etc/docker/daemon.json 文件：该命令会将 NVIDIA 容器运行时的配置信息写入
    运行指令后，会出现如下内容：
    ```
    INFO[0000] Loading config from /etc/docker/daemon.json  
    INFO[0000] Wrote updated config to /etc/docker/daemon.json 
    INFO[0000] It is recommended that docker daemon be restarted. 
    ```
2. 重启docker:```sudo systemctl restart docker```
3. 查看配置文件:```cat /etc/docker/daemon.json```
   会出现如下内容在配置文件中：
   ```
    {       "runtimes": {
            "nvidia": {
                "args": [],
                "path": "nvidia-container-runtime"
            }
        }
    }
   ```
4. 查看docker 支持的运行时有没有nvidia```docker info | grep Runtimes```
   但输出内容为```Runtimes: io.containerd.runc.v2 runc```，这表明 Docker 目前没有正确配置 nvidia 作为容器运行时。因此，Docker 容器无法使用 NVIDIA GPU。当输出内容为：```Runtimes: io.containerd.runc.v2 nvidia runc```。


## 启动容器，运行nvidia-smi查看效果

    ```$ sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi```


## 查看是否安装
- `dpkg -l | grep nvidia-container-runtime`,如果你没有看到类似 nvidia-container-runtime 的输出，则需要安装它

## 查看系统是否有安装包
- 检查 Ubuntu 是否已经有 NVIDIA 相关的包，`apt-cache search nvidia | grep container`，如果搜索结果中包含 nvidia-container-runtime，那么你可以尝试直接安装：`sudo apt-get install -y nvidia-container-runtime`，但大概率会 找不到，因为这个包一般只存在于 NVIDIA 官方软件源。
