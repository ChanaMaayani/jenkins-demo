pipeline {
    agent any

    environment {
        IMAGE_NAME = "test-image"
        CONTAINER_NAME = "test-container"
        HOST_PORT = "8081"
        CONTAINER_PORT = "80" // פורט ה-NGINX בקונטיינר
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Running Docker container...'
                sh """
                # אם הקונטיינר קיים, להפסיק ולהסיר
                if [ \$(docker ps -a -q -f name=${CONTAINER_NAME}) ]; then
                    echo 'Container already exists. Removing...'
                    docker stop ${CONTAINER_NAME}
                    docker rm ${CONTAINER_NAME}
                fi

                # להריץ קונטיינר חדש
                docker run -d --name ${CONTAINER_NAME} -p ${HOST_PORT}:${CONTAINER_PORT} ${IMAGE_NAME}
                """
            }
        }

        stage('Check Container Status') {
            steps {
                echo 'Checking if container is running...'
                sh """
                if docker ps | grep -q ${CONTAINER_NAME}; then
                    echo "Container is running ✅"
                else
                    echo "Container is NOT running ❌"
                    docker logs ${CONTAINER_NAME}  # מדפיס לוגים אם הוא יצא מיד
                    exit 1
                fi
                """
            }
        }

        stage('Stop and Remove Container') {
            steps {
                echo 'Stopping and removing container...'
                sh """
                docker stop ${CONTAINER_NAME}
                docker rm ${CONTAINER_NAME}
                """
            }
        }
    }
}
