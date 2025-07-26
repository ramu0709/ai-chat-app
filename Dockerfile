FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt update && apt install -y \
    git \
    curl \
    build-essential \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install CPU-only torch and torchvision
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision==0.17.2+cpu \
    -f https://download.pytorch.org/whl/torch_stable.html

# Copy requirements and install dependencies
COPY requirements.txt .
RUN for i in 1 2 3; do \
    pip install --no-cache-dir --timeout=300 -r requirements.txt && break || sleep 10; \
done

# Copy app code
COPY . .

# Expose Gradio/Flask port
EXPOSE 7860

# Run chatbot
CMD ["python", "chatbot.py"]
