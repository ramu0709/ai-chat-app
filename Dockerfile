FROM python:3.10-slim

WORKDIR /app

# 🧰 Install system dependencies
RUN apt update && apt install -y \
    git \
    curl \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# ⬆️ Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# 🧠 Install CPU-only PyTorch stack
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 📦 Install remaining dependencies from requirements.txt with retry
COPY requirements.txt .
RUN for i in 1 2 3; do \
      pip install --no-cache-dir -r requirements.txt \
      && pip show gradio && break \
      || (echo "[ERROR] ❌ gradio install attempt $i failed, retrying..." && sleep 5); \
    done

# ✅ Final safety: check gradio is installed or fail early
RUN pip show gradio || (echo "[FINAL ERROR] ❌ gradio not installed after retries!" && exit 1)

# 📋 Show all installed packages (for debugging)
RUN pip list

# 📁 Copy app files
COPY . .

# 🌐 Expose Gradio web UI port
EXPOSE 7860

# 🚀 Run chatbot
CMD ["python", "chatbot.py"]
