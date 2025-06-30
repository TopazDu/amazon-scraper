# 使用官方Python基础镜像（可根据需要替换版本）
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装curl和必要工具
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# 安装Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# 添加Poetry到PATH环境变量
ENV PATH="/root/.local/bin:$PATH"

# 复制项目文件到容器
COPY . .

# 配置Poetry不创建虚拟环境，直接安装依赖到系统环境
RUN poetry config virtualenvs.create false

# 安装所有依赖（包括dev依赖，如果你想排除dev依赖，可以稍后告诉我具体需求）
RUN poetry install --no-interaction --no-ansi

# 如果你项目有启动命令，替换下面的CMD
CMD ["python", "api.py"]
