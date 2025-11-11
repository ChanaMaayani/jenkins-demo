pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "my-web-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh '''
                    docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                '''
            }
        }

        stage('Run Container (Test)') {
            steps {
                echo 'Running container for testing...'
                script {
                    sh '''
                        # מנקים אם יש קונטיינר ישן
                        docker rm -f test-container || true

                        # מריצים קונטיינר חדש ברקע
                        docker run -d --name test-container -p 8081:80 ${DOCKER_IMAGE}:${DOCKER_TAG}

                        # מחכים כמה שניות שיעלה
                        sleep 3

                        # בודקים שהקובץ index.html קיים (סימן שהכל תקין)
                        docker exec test-container ls /usr/share/nginx/html/index.html

                        echo "Container is running successfully!"
                    '''
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo 'Stopping and removing test container...'
                sh 'docker rm -f test-container || true'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
            sh 'docker rm -f test-container || true'
        }
    }
}
