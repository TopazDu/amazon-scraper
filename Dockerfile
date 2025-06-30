FROM python:3.11-slim

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 安装 Poetry（最新版本）
RUN curl -sSL https://install.python-poetry.org | python3 -

# 把 Poetry 添加到环境变量路径
ENV PATH="/root/.local/bin:$PATH"

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器
COPY . .

# 安装 Python 依赖（排除开发依赖）
RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --without dev

# 运行项目，改成你的启动命令
CMD ["python", "api.py"]
