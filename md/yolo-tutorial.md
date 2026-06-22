# yolo

## 环境配置
1. 命令如下：
    ```
    # Clone the ultralytics repository
    git clone https://github.com/ultralytics/ultralytics

    # Navigate to the cloned directory
    cd ultralytics

    # Install the package in editable mode for development
    pip install -e .
    ```
2. 上述环境配置，torch等并未安装gpu版本，需替换为gpu版本，
    ```
    # yolo 12,11,8
    torch                                2.6.0+cu118
    torchvision                          0.21.0+cu118
    ```
## 数据集路径问题

1. 在使用 YOLO 进行训练时，如果出现找不到训练集和测试集文件的问题，通常是由于路径配置错误导致的。

    YOLO 在查找路径时，会将以下三部分拼接起来：
     - `settings` 中的 `datasets_dir`
     - 数据集配置的 YAML 文件中的 `path`
     - 数据集配置的 YAML 文件中的 `train` 和 `val`
2. 通过以下方式来修改 datasets_dir：
    ```bash
    # 方式一
    from ultralytics import settings

    # View all settings
    print(settings)

    # Return a specific setting
    value = settings["runs_dir"]

    from ultralytics import settings

    # Update a setting
    settings.update({"runs_dir": "/path/to/runs"})

    # Update multiple settings
    settings.update({"runs_dir": "/path/to/runs", "tensorboard": False})

    # Reset settings to default values
    settings.reset()

    # 方式二（推荐）
    sudo vim ~/.config/Ultralytics/settings.json 
    yolo export model=./9173.pt format=engine imgsz=640 half=True device=0
    ```
