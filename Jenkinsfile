pipeline {
    agent any

    environment {
        HUGGINGFACE_TOKEN = credentials('huggingface-token') // Jenkins Secret Text ID
    }

    stages {
        stage('Run AI Chatbot (CPU only)') {
            steps {
                script {
                    echo "[INFO] 🧠 Running chatbot with cached Hugging Face model..."

                    sh '''
                    docker run --rm -p 7860:7860 \
                        -e HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN \
                        -v ~/.cache/huggingface:/root/.cache/huggingface \
                        mistral-chatbot
                    '''
                }
            }
        }
    }
}
