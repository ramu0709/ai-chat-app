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

# 🧠 Install CPU-only PyTorch
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# 📦 Copy and install other requirements (except gradio)
COPY requirements.txt .
RUN pip install --no-cache-dir accelerate==0.30.1 sentencepiece==0.2.0 protobuf==4.25.3 transformers==4.40.2 pydantic==1.10.15

# ✅ Install gradio separately with retry logic
RUN for i in 1 2 3; do \
      pip install --no-cache-dir gradio==4.27.0 \
      && pip show gradio && break \
      || (echo "[WARN] 🔁 gradio install attempt $i failed, retrying..." && sleep 5); \
    done

# ❌ Fail early if gradio still not installed
RUN pip show gradio || (echo "[FINAL ERROR] ❌ gradio not installed after retries!" && exit 1)

# 🗂️ Copy all app files
COPY . .

# 🌐 Expose port for Gradio UI
EXPOSE 7860

# 🚀 Launch the chatbot
CMD ["python", "chatbot.py"]
