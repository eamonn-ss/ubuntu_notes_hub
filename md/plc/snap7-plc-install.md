# snap7(plc)

## 安装步骤

1. 登录[Snap官网](https://snap7.sourceforge.net/)，找到download，选择1.4.2下载7z包。

2. [Snap_github](https://github.com/davenardella/snap7)有不同平台的安装步骤

3. 在linux下：

    ```pyhton
    sudo apt update
    sudo apt install build-essential cmake git python3-dev
    cd snap7-full-1.4.2/build/unix
    # 删除之前编译生成的中间文件和产物（比如 .o 对象文件、可执行文件、.so 动态库等）。
    sudo make -f x86_64_linux.mk clean
    # 执行完整的构建过程：
    # 编译所有 .cpp / .c 源文件生成 .o 对象文件
    # 链接生成最终的 libsnap7.so（动态库）和工具程序（如 client、server）
    sudo make -f x86_64_linux.mk all
    # 把编译好的文件复制到系统目录，方便其他程序直接调用。
    # 常见安装路径
    # /usr/local/lib/ → 动态库 libsnap7.so
    # /usr/local/include/ → 头文件 snap7.h 等
    # /usr/local/bin/ → 可执行工具（如果有）
    sudo make -f x86_64_linux.mk install
    ```
    编译成功后会生成 libsnap7.so，一般在类似下面的位置之一：`~/snap7-full-1.4.2/build/bin/x86_64-linux/libsnap7.so`，执行完 install 之后，可以用`ldconfig -p | grep snap7`，检查系统是否已经识别到 libsnap7.so


4. 安装共享库到系统路径并刷新缓存

    ```python
    sudo cp /实际路径/到/libsnap7.so /usr/local/lib/
    cd /usr/local/lib/
    sudo ln -sf libsnap7.so libsnap7.so.1
    sudo ldconfig
    ```
    放到 /usr/lib 也可以，但放 /usr/local/lib 更常见。ldconfig 是 Linux 下 管理动态链接库 (shared libraries) 的一个系统工具，全称是 linker dynamic config。ldconfig 就是 Linux 里动态库的“目录刷新器”，新库装好后跑一下，它就能让程序找到库。刷新所有库缓存：`sudo ldconfig`查看当前系统缓存里已注册的库：`ldconfig -p`。系统中有很多 .so 动态库文件（比如 libsnap7.so）。ldconfig 会扫描配置文件里指定的目录（默认 /lib、/usr/lib、/usr/local/lib 等），找到所有 .so，并更新缓存 /etc/ld.so.cache。这样程序启动时，动态链接器 ld.so 就能快速找到需要的库。