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

# Copy requirements and install them with retry logic
COPY requirements.txt .
RUN for i in 1 2 3; do pip install --no-cache-dir -r requirements.txt && break || sleep 5; done

# Copy project files
COPY . .

# Expose the Gradio web port
EXPOSE 7860

# Run the chatbot
CMD ["python", "chatbot.py"]
