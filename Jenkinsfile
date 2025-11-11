pipeline {
    agent any

    environment {
        IMAGE_NAME = "test-image"
        CONTAINER_NAME = "test-container"
        PORT = "8081"
        NGINX_PORT = "80"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/ChanaMaayani/jenkins-demo.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running Docker container..."
                // בדיקה אם קונטיינר קיים
                sh """
                    if [ \$(docker ps -a -q -f name=${CONTAINER_NAME}) ]; then
                        echo "Container already exists. Removing..."
                        docker stop ${CONTAINER_NAME} || true
                        docker rm ${CONTAINER_NAME} || true
                    fi
                    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${NGINX_PORT} ${IMAGE_NAME}
                """
            }
        }

        stage('Check Container Status') {
            steps {
                echo "Checking if container is running..."
                script {
                    def isRunning = sh(script: "docker ps -q -f name=${CONTAINER_NAME}", returnStdout: true).trim()
                    if (!isRunning) {
                        echo "Container is NOT running ❌"
                        sh "docker logs ${CONTAINER_NAME} || true"
                        error("Container failed to start")
                    } else {
                        echo "Container is running ✅"
                    }
                }
            }
        }
    }

    post {
        failure {
            echo "Pipeline failed. Cleaning up..."
            sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
            """
        }
    }
}
