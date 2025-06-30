FROM python:3.11-slim

# 安装依赖
RUN apt-get update && apt-get install -y \
    curl \
    make \
    wget \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# 添加 Google Chrome 的 GPG 密钥
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

# 更新并安装 Chromium 浏览器
RUN apt-get update && apt-get install -y chromium

# 安装 ChromeDriver
# 确保 Chromium 已经成功安装
# 获取 Chromium 版本号
RUN CHROMIUM_VERSION=$(chromium --version | awk '{print $2}' | sed 's/\([0-9]*\)\.[0-9]*\.[0-9]*/\1/') \
    && echo "Detected Chromium version: $CHROMIUM_VERSION" \
    # 访问 ChromeDriver 官方网站（https://chromedriver.chromium.org/downloads）
    # 查找与你的 Chromium 版本（例如，主版本号）兼容的 ChromeDriver 下载链接
    # 注意：ChromeDriver 的版本通常与 Chrome/Chromium 的主版本号保持一致。
    # 
    # 以下是一个示例，你需要根据实际的 Chromium 版本来更新下载链接。
    # 假设你的 Chromium 主版本号是 126，你可能需要下载 126.0.6478.61 版本的 ChromeDriver。
    # 通常，可以从 https://edgedl.me.gvt1.com/edgedl/chrome/chromedriver/LATEST_RELEASE_$(CHROMIUM_VERSION) 获取最新兼容版本号
    # 或者直接去 https://chromedriver.chromium.org/downloads 查找。
    #
    # 为了自动化，通常建议先获取最新兼容版本号，再下载。
    && LATEST_CHROMEDRIVER_VERSION=$(wget -q -O - https://edgedl.me.gvt1.com/edgedl/chrome/chromedriver/LATEST_RELEASE_${CHROMIUM_VERSION}) \
    && echo "Latest compatible ChromeDriver version: $LATEST_CHROMEDRIVER_VERSION" \
    && wget -N https://chromedriver.storage.googleapis.com/${LATEST_CHROMEDRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

WORKDIR /app

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="/root/.local/bin:$PATH"

COPY . .

# 配置 Poetry 不创建虚拟环境
RUN poetry config virtualenvs.create false

# 安装所有依赖
RUN poetry install --no-interaction --no-ansi

# 运行应用
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
