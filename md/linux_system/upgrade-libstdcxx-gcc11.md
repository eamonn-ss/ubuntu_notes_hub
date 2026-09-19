# 手动升级 libstdc++（推荐）
## 由于 APT 找不到 libstdc++-11-dev，我们可以 手动下载并安装 GCC 11，从而获取 libstdc++.so.6 的更新版本。
1. 步骤 1：更新 APT 并安装 GCC
    ```
    apt-get update
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:ubuntu-toolchain-r/test
    apt-get update
    apt-get install -y gcc-11 g++-11
    sudo apt-get install -y libstdc++6 # 如果需要安装，添加 PPA 并升级 libstdc++6
    ```
2. 步骤 2：检查 libstdc++.so.6 版本
   ```
   strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX
   ```
   如果 GLIBCXX_3.4.29 出现，说明已成功升级。

3. 步骤 3：手动替换 libstdc++.so.6

    如果 libstdc++.so.6 仍然是旧版本，你可以手动替换：
    ```
    cd /usr/lib/x86_64-linux-gnu/
    mv libstdc++.so.6 libstdc++.so.6.bak
    ln -s /usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.so libstdc++.so.6
    ```
    然后再次检查：
    ```
    strings libstdc++.so.6 | grep GLIBCXX
    ```
    `ln -sf /usr/lib/gcc/x86_64-linux-gnu/10/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6`


# 步骤 1：安装 GCC 11 和依赖
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install -y gcc-11 g++-11
# libstdc++6 是 gcc-11 的依赖项，无需单独安装
sudo apt-get install -y libstdc++6

# 步骤 2：检查版本
strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX
#strings /usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.so.6 | grep GLIBCXX_3.4.30

# 步骤 3：手动更新库（谨慎操作）
sudo mv /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.bak
sudo ln -s /usr/lib/gcc/x86_64-linux-gnu/11/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6

# 步骤 4：验证
ls -l /usr/lib/x86_64-linux-gnu/libstdc++.so.6
strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX_3.4.30

# 步骤 5：修复 Conda 环境（可选）
ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 $CONDA_PREFIX/lib/libstdc++.so.6
或是
ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /home/ss/miniforge3/envs/py38/bin/../lib/libstdc++.so.6
