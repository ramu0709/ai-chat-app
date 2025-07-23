pipeline {
    agent any

    environment {
        HUGGINGFACE_TOKEN = credentials('hf-token')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ramu0709/ai-chat-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t mistral-chatbot .'
            }
        }

        stage('Run AI Chatbot (CPU)') {
            steps {
                sh '''
                    docker run --rm \
                      -e HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN \
                      mistral-chatbot
                '''
            }
        }
    }
}
