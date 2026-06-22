# Python 项目结构设计

## 对比表

    | 文件名                | 用途                    | 谁用它                                  | 推荐用法     |
    | ------------------ | --------------------- | ------------------------------------ | -------- |
    | `requirements.txt` | 📦 安装依赖列表（面向用户/开发者）   | `pip`                                | 最基础，人人可用 |
    | `setup.cfg`        | ⚙️ 项目元信息 + 依赖（声明式）    | `setuptools`                         | 项目发布用 ✅  |
    | `pyproject.toml`   | 🧱 构建系统入口（PEP 518 标准） | `pip`, `build`, `hatch`, `poetry`, 等 | 现代构建标准 ✅ |

## requirements.txt

- 列出项目所需依赖包（面向用户），常用于快速安装开发环境或部署环境

- eg:

    ```bash
    torch==2.2.0
    torchvision==0.17.0
    ultralytics==8.2.100
    opencv-python>=4.5
    numpy
    PyYAML
    ```

- 安装命令：`pip install -r requirements.txt`

- 特点：简单直接，不含项目名、作者、版本信息，不能构建 wheel / 发布 PyPI 包

## setup.cfg（配合 setup.py 或单独使用）

- 管理项目元信息（项目名、版本、作者、依赖等），配合 setuptools 用于构建、打包、发布项目

- eg:

    ```bash
    [metadata]
    name = holescan
    version = 0.1.0
    author = Your Name
    description = Hole detection with YOLO
    long_description = file: README.md
    license = MIT

    [options]
    packages = find:
    python_requires = >=3.10
    install_requires =
        torch==2.2.0
        torchvision==0.17.0
        ultralytics==8.2.100
    ```

- 特点：格式是 INI，声明式配置（无需写 Python 代码），可替代 setup.py 实现无代码构建

## pyproject.toml（PEP 518/621 标准）

- 声明你的构建工具（如 setuptools、poetry、hatch），是 Python 官方现代项目的推荐构建入口，Pip 安装时读取它来决定如何构建项目

- eg:

    ```bash
    [build-system]
    requires = ["setuptools>=61.0"]
    build-backend = "setuptools.build_meta"

    [project]
    name = "holescan"
    version = "0.1.0"
    dependencies = [
    "torch==2.2.0",
    "torchvision==0.17.0"
    ]
    ```

- 特点：替代 setup.py + setup.cfg 成为未来标准，格式为 TOML，结构清晰，支持 pip install -e .、构建 wheel 等，用于现代构建系统如 Poetry、Hatch、PDM

- 完整规范请参考 [PEP 621 官方文档](https://peps.python.org/pep-0621/#dynamic)和[PEP 508 官方文档](https://peps.python.org/pep-0508/)