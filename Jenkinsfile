pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t test-image .'
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Running Docker container...'
                // אם קיים קונטיינר כזה, עוצרים ומוחקים אותו
                sh '''
                if [ $(docker ps -a -q -f name=test-container) ]; then
                    echo "Container already exists. Removing..."
                    docker stop test-container
                    docker rm test-container
                fi
                docker run -d --name test-container -p 8081:8081 test-image
                '''
            }
        }

        stage('Check Container Status') {
            steps {
                echo 'Checking if container is running...'
                sh '''
                if docker ps | grep -q test-container; then
                    echo "Container is running ✅"
                else
                    echo "Container is NOT running ❌"
                    exit 1
                fi
                '''
            }
        }

        stage('Stop and Remove Container') {
            steps {
                echo 'Cleaning up...'
                sh '''
                docker stop test-container
                docker rm test-container
                '''
            }
        }
    }
}
