FROM python:3.10-slim

# System dependencies
RUN apt update && apt install -y \
    git curl build-essential libffi-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Use older compatible NumPy
RUN pip install --no-cache-dir numpy<2

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install PyTorch (CPU-only) and other deps
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision==0.17.2+cpu \
    -f https://download.pytorch.org/whl/torch_stable.html

# Install remaining dependencies including protobuf fix
COPY requirements.txt .
RUN for i in 1 2 3; do \
    pip install --no-cache-dir -r requirements.txt && break || sleep 10; \
done

# Optional: Force protobuf install again
RUN pip install --no-cache-dir protobuf google

# Copy all files
COPY . .

EXPOSE 7860
CMD ["python", "chatbot.py"]
