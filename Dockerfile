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
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | sed 's/\([0-9]*\)\.[0-9]*\.[0-9]*/\1/') \
    && wget -N https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip \
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
