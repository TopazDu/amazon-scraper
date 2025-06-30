FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件到容器中
COPY . .

# 安装系统依赖（为了构建依赖包）
RUN apt-get update && apt-get install -y build-essential

# 安装 Poetry，并使用它安装依赖
RUN pip install poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev

# 安装 FastAPI 和 Uvicorn，用于运行 api.py
RUN pip install fastapi uvicorn

# 暴露 FastAPI 监听的端口
EXPOSE 8000

# 启动 API 服务
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
