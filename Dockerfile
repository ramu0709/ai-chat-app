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

# 📦 Copy and install requirements with fallback for gradio
COPY requirements.txt .
RUN for i in 1 2 3; do \
    pip install --no-cache-dir -r requirements.txt && break || sleep 5; \
done

# 🛠️ Manually install gradio again (just in case)
RUN pip install --no-cache-dir gradio==4.27.0

# ✅ Confirm gradio installed or fail early
RUN python -c "import gradio" || (echo '[ERROR] ❌ Gradio still not available!' && exit 1)

# 📋 List installed packages for debugging
RUN pip list

# 🧠 Copy all project files
COPY . .

# 🌐 Expose port for Gradio
EXPOSE 7860

# 🚀 Start chatbot
CMD ["python", "chatbot.py"]
