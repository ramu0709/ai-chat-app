# 🐍 Use slim Python base image
FROM python:3.10-slim

# 📂 Set working directory
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

# 📦 Copy requirements file
COPY requirements.txt .

# 📥 Install Python packages from requirements.txt (retry loop)
RUN for i in 1 2 3; do \
    pip install --no-cache-dir -r requirements.txt && break || sleep 5; \
done

# 🧠 Manually ensure critical packages are present
RUN pip install --no-cache-dir \
    gradio==4.27.0 \
    transformers==4.41.1 \
    accelerate==0.30.1

# ✅ Confirm gradio and transformers are installed, fail if not
RUN python -c "import gradio, transformers" || (echo '[ERROR] ❌ Critical packages missing!' && exit 1)

# 📋 Show installed packages (debugging)
RUN pip list

# 📂 Copy source code
COPY . .

# 🌐 Expose Gradio UI port
EXPOSE 7860

# 🚀 Start the chatbot app
CMD ["python", "chatbot.py"]
