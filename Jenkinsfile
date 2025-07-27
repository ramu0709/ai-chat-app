pipeline {
    agent any

    environment {
        HUGGINGFACE_TOKEN = credentials('huggingface-token') // Jenkins secret ID
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ramu0709/ai-chat-app.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    writeFile file: '.env', text: "HUGGINGFACE_TOKEN=" + HUGGINGFACE_TOKEN
                }
                sh '''
                    echo "[INFO] 🐳 Building Docker image..."
                    docker build -t mistral-chatbot .
                    rm .env
                '''
            }
        }

        stage('Run AI Chatbot (CPU only)') {
            steps {
                script {
                    writeFile file: '.env', text: "HUGGINGFACE_TOKEN=" + HUGGINGFACE_TOKEN
                }
                sh '''
                    echo "[INFO] 🧠 Starting Mistral chatbot on CPU..."
                    docker run --rm -p 7860:7860 --env-file .env mistral-chatbot || true
                    rm .env
                '''
            }
        }
    }
}
