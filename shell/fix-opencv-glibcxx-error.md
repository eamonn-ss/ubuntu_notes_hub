在虚拟环境中安装opencv要确保numpy已安装。

You've successfully installed OpenCV '4.5.5' on your PC
(mujoco) ss@ss-Dell-G15-5530:~$ python
Python 3.8.20 (default, Oct  3 2024, 15:24:27) 
[GCC 11.2.0] :: Anaconda, Inc. on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import cv2
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/home/ss/miniconda3/envs/mujoco/lib/python3.8/site-packages/cv2/__init__.py", line 181, in <module>
    bootstrap()
  File "/home/ss/miniconda3/envs/mujoco/lib/python3.8/site-packages/cv2/__init__.py", line 153, in bootstrap
    native_module = importlib.import_module("cv2")
  File "/home/ss/miniconda3/envs/mujoco/lib/python3.8/importlib/__init__.py", line 127, in import_module
    return _bootstrap._gcd_import(name[level:], package, level)
ImportError: /home/ss/miniconda3/envs/mujoco/lib/libstdc++.so.6: version `GLIBCXX_3.4.30' not found (required by /home/ss/miniconda3/envs/mujoco/lib/libopencv_gapi.so.405)
不兼容的 GCC 版本：你当前使用的 GCC 版本可能不支持 GLIBCXX_3.4.30，或者你的 libstdc++ 库版本过旧。
环境问题：你正在使用 Anaconda 环境，可能导致了一些库的版本不匹配。
sudo apt update
sudo apt upgrade
sudo apt install libstdc++6

sudo apt install gcc-10 g++-10
sudo apt install libstdc++-10-dev


conda install libgcc=9.3.0
conda install libstdcxx-ng

sudo find / -name 'libstdc++.so.6'
sudo ln -sf /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /home/ss/miniconda3/envs/mujoco/lib/libstdc++.so.6
ls -l /home/ss/miniconda3/envs/mujoco/lib/libstdc++.so.6

sudo rm /home/ss/miniconda3/envs/mujoco/lib/libstdc++.so.6
ls -l /home/ss/miniconda3/envs/mujoco/lib/libstdc++.so.6

strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX


