FROM python:3.10-slim

WORKDIR /app

# ✅ Install system packages required by gradio and others
RUN apt update && apt install -y \
    git \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1 \
    pkg-config \
    libcairo2 \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# ✅ Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# ✅ Install PyTorch (CPU only)
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# ✅ Install remaining dependencies with retry logic
COPY requirements.txt .
RUN for i in 1 2 3; do pip install --no-cache-dir -r requirements.txt && break || sleep 5; done

# ✅ Confirm gradio installed (fails early if not)
RUN pip show gradio || (echo "[ERROR] ❌ gradio not installed!" && exit 1)

# Show all packages (optional debug)
RUN pip list

# Copy app files
COPY . .

EXPOSE 7860

CMD ["python", "chatbot.py"]
