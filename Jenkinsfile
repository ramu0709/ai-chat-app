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
                withCredentials([string(credentialsId: 'huggingface-token', variable: 'HUGGINGFACE_TOKEN')]) {
                    sh '''
                        echo "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}" > .env
                        docker build -t mistral-chatbot .
                        rm .env
                    '''
                }
            }
        }

        stage('Run AI Chatbot (CPU)') {
            steps {
                withCredentials([string(credentialsId: 'huggingface-token', variable: 'HUGGINGFACE_TOKEN')]) {
                    sh '''
                        echo "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}" > .env
                        docker run --rm --env-file .env mistral-chatbot || true
                        rm .env
                    '''
                }
            }
        }
    }
}
