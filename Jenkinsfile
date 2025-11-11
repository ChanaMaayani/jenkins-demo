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
                // מריצים את הקונטיינר ברקע עם שמירה על השם
                sh 'docker run -d --name test-container -p 8081:8081 test-image'
            }
        }

        stage('Check Container Status') {
            steps {
                echo 'Checking if container is running...'
                // במקום curl, נוודא שהקונטיינר ברשימת הקונטיינרים
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
