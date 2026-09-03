# mujoco安装教程

## 安装mujoco

1. Mujoco 是闭源软件，安装前需要去官网下载许可证以及安装包。从官网下载mujoco210安装文件
2. 创建一个隐藏的文件夹，`mkdir ~/.nujoco`
3. 找到创建的隐藏文件夹
4. 缩包所在位置（一般在下载目录下）在终端打开，输入以下命令将压缩包解压到.mujoco文件夹中：`tar -zxvf mujoco210-linux-x86_64.tar.gz -C ~/.mujoco`
5. 获取许可文件mjket.txt,许可文件下载[链接](https://www.roboti.us/license.html),并将下载的mjkey.txt文件拷贝到.mujoco文件夹和.mujoco\mujoco200\bin文件夹下即可。
6. 配置环境变量，命令行输入`sudo gedit ~/.bashrc`,在打开的文件最后添加如下代码，注意xxx是ubuntu的用户名。
    ```bash
    export MUJOCO_KEY_PATH=~/.mujoco${MUJOCO_KEY_PATH}
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/XXX/.mujoco/mujoco210/bin
    ```
7. 保存关闭后，在命令行输入`source ~/.bashrc`
8. 测试mujoco，
    ```bash
    cd ~/.mujoco/mujoco210/bin
    ./simulate ../model/humanoid.xml
    ```
1. 出现如下画面表示安装成功

## 安装mujoco-py

1. conda中创建一个新的环境，`conda create -n mujoco python=3.8`
2. 激活环境，`conda activate mujoco`
3. 下载mujoco-py，注意要退回主目录下，将mujoco-py下载在主目录下
    ```bash
    # 下载mujoco_py
    git clone https://github.com/openai/mujoco-py.git
    # 进入mujoco_py文件夹
    cd mujoco-py
    # 安装依赖
    pip install -r requirements.txt
    # 安装mujoco_py
    pip3 install -U 'mujoco-py<2.2,>=2.1'
    ```
4. 配置环境变量，命令行输入`sudo gedit ~/.bashrc`，在打开的文件最后添加如下代码：
    ```bash
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/nvidia 
    ```
5. 保存关闭后，在命令行输入`source ~/.bashrc`
6. 测试mujoco-py，在主目录下，转到mujoco-py/examples文件夹下：`cd ~/mujoco-py/examples/`
7. 输入以下进行测试：`python body_interaction.py`
8. 测试成功如下。

## 安装mujoco-py常遇到问题解决方案

1. 报错：command ‘gcc‘ failed with exit status 1

    执行以下命令：
    ```bash
    sudo apt-get install build-essential
    sudo apt-get install build-essential libgl1-mesa-dev
    sudo apt-get install libglew-dev libsdl2-dev libsdl2-image-dev libglm-dev libfreetype6-dev
    sudo apt-get install libglfw3-dev libglfw3
    ```
2. 报错：No such file or directory: ‘patchelf’

    执行以下命令：
     ```bash
    sudo apt-get install patchelf
    ```
3. 报错：Missing GL version

    执行以下命令：
    ```bash
    sudo gedit ~/.bashrc
    export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so
    source ~/.bashrc
    ```
    和
    ```bash
    sudo apt-get install  libglew-dev
    sudo apt-get install libglfw3 libglfw3-dev
    ```
4. 报错：Error compiling Cython file:
   执行以下命令：

   `pip install "cython<3"`
5. GLIBCXX_3.4.29 not found: 这是由于系统的 GCC 版本较低，升级 GCC 后即可解决
   ```bash
   sudo apt install build-essential
    sudo apt install gcc-10 g++-10
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
    sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10

   ```
6. 报错：GlfwError: Failed to create GLFW window，可能是现没有使用 NVIDIA 显卡的问题
    检查当前 PRIME 模式:`prime-select query`,如果返回 intel，说明系统正在使用 Intel 集显。如果返回 nvidia，说明系统应该使用 NVIDIA 显卡，但可能配置有问题。切换到 NVIDIA 模式:`sudo prime-select nvidia`,然后重启机器。
   
7. libGL error: MESA-LOADER: failed to open irislibGL error: MESA-LOADER: failed to open iris,这个报错只有一条，下面还有好几条libGL error，出现这种情况很可能是核显和独显同时使用了，在ubuntu下解决方案是：
    - 确定自己安装了NVIDIA的显卡驱动，可在终端输入nvidia-smi，可以查看是否有输出信息，如有则表明安装了
    - 终端输入nvidia-settings，弹出nvidia settings设置窗口，点击左侧的最后一项PRIME Profiles，选择nvidia（performance mode），然后重启。

