pipeline {
  agent any

  environment {
    IMAGE_NAME = "mistral-chatbot"
  }

  stages {
    stage('Build Docker Image') {
      steps {
        withCredentials([string(credentialsId: 'hf-token', variable: 'HUGGINGFACE_TOKEN')]) {
          sh '''
            echo "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}" > .env
            docker build -t $IMAGE_NAME .
            rm .env
          '''
        }
      }
    }

    stage('Run AI Chatbot (CPU)') {
      steps {
        withCredentials([string(credentialsId: 'hf-token', variable: 'HUGGINGFACE_TOKEN')]) {
          sh '''
            echo "HUGGINGFACE_TOKEN=${HUGGINGFACE_TOKEN}" > .env
            docker run --env-file .env $IMAGE_NAME
            rm .env
          '''
        }
      }
    }
  }
}
