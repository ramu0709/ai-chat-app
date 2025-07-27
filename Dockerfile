# Use lightweight Python image
FROM python:3.10-slim

# Set working directory
WORKDIR /app

# System packages required for sentencepiece and SSL
RUN apt update && apt install -y \
    git \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip to latest version
RUN pip install --no-cache-dir --upgrade pip

# Install CPU-only Torch and torchvision
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision==0.17.2+cpu \
    -f https://download.pytorch.org/whl/torch_stable.html

# Copy requirements first
COPY requirements.txt .

# Retry logic for slow installs
RUN for i in 1 2 3; do \
      pip install --no-cache-dir --timeout=300 -r requirements.txt && break || sleep 10; \
    done

# Copy all code
COPY . .

# Expose default chatbot port
EXPOSE 7860

# Default command
CMD ["python", "chatbot.py"]
