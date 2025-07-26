pipeline {
    agent any

    environment {
        HUGGINGFACE_TOKEN = credentials('huggingface-token') // Jenkins secret token
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/ramu0709/ai-chat-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    writeFile file: '.env', text: "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}"
                }
                sh '''
                    echo "[INFO] 🔨 Building mistral-chatbot image..."
                    docker build -t mistral-chatbot .
                    rm -f .env
                '''
            }
        }

        stage('Run AI Chatbot (CPU only)') {
            steps {
                script {
                    writeFile file: '.env', text: "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}"
                }
                sh '''
                    echo "[INFO] 🧠 Running chatbot with cached Hugging Face model..."

                    docker run --rm \
                      -p 7860:7860 \
                      --env-file .env \
                      -v /home/ramu7/.cache/huggingface:/root/.cache/huggingface \
                      mistral-chatbot

                    rm -f .env
                '''
            }
        }
    }
}
