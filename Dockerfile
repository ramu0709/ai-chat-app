FROM python:3.10-slim

WORKDIR /app

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y git && rm -rf /var/lib/apt/lists/*

# Copy files
COPY requirements.txt ./
COPY chatbot.py ./
COPY .env ./

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Entrypoint
CMD ["python", "chatbot.py"]
