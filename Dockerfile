FROM python:3.10-slim

WORKDIR /app

# Required build dependencies for gradio & others
RUN apt update && apt install -y \
    git \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install PyTorch (CPU-only)
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Copy requirements first and install dependencies
COPY requirements.txt .
RUN for i in 1 2 3; do pip install --no-cache-dir -r requirements.txt && break || sleep 5; done

# ✅ Extra safety: Explicitly confirm gradio is installed
RUN pip show gradio || (echo "[ERROR] ❌ gradio not installed!" && exit 1)

# Show all installed packages (for debug)
RUN pip list

# Copy app code
COPY . .

EXPOSE 7860

CMD ["python", "chatbot.py"]
