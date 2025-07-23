FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt ./

# Install torch manually to avoid GPU/cuda
RUN pip install --no-cache-dir torch==2.2.2+cpu torchvision==0.17.2+cpu -f https://download.pytorch.org/whl/torch_stable.html

# Install other packages
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "chatbot.py"]
