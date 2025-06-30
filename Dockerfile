FROM python:3.11

# 更新并安装基本依赖和 Google Chrome
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    gnupg2 \
    && wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome.deb \
    && rm google-chrome.deb \
    && rm -rf /var/lib/apt/lists/*

# 验证 Chrome 是否正确安装
RUN google-chrome --version

# 安装 ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1) \
    && CHROMEDRIVER_VERSION=$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION) \
    && wget -N https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

WORKDIR /app

# 安装 Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

COPY . .

# 配置 Poetry 不创建虚拟环境
RUN poetry config virtualenvs.create false

# 安装所有依赖
RUN poetry install --no-interaction --no-ansi

# 运行应用
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
