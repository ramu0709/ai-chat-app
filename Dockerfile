FROM python:3.10-slim

WORKDIR /app

# 🧰 Install system dependencies
RUN apt update && apt install -y \
    git \
    curl \
 && apt clean \
 && rm -rf /var/lib/apt/lists/*

# 🐍 Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# 🔥 Install PyTorch (CPU-only)
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 📦 Copy and install Python dependencies with retry logic
COPY requirements.txt .
RUN for i in 1 2 3; do pip install --no-cache-dir -r requirements.txt && break || sleep 5; done

# ✅ Final safety: check gradio is installed or fail early
RUN pip show gradio || (echo "[FINAL ERROR] ❌ gradio not installed after retries!" && exit 1)

# 📋 Optional debug: list installed packages
RUN pip list

# 🧠 Copy app source code
COPY . .

# 🌐 Expose Gradio UI port
EXPOSE 7860

# 🚀 Start the chatbot
CMD ["python", "chatbot.py"]
