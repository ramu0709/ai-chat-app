FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt update && apt install -y \
    git \
    curl \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install PyTorch (CPU-only)
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Copy requirements first to use Docker cache properly
COPY requirements.txt .

# Retry pip install if fails
RUN for i in 1 2 3; do pip install --no-cache-dir -r requirements.txt && break || sleep 5; done

# 🔍 DEBUG: confirm gradio installed (you can remove this later)
RUN pip list

# Copy source code
COPY . .

EXPOSE 7860

# Run app
CMD ["python", "chatbot.py"]
