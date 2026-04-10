pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker_aws_login')
        IMAGE_NAME = '908340073825.dkr.ecr.us-east-1.amazonaws.com/helloapp'  // Change to your Docker Hub repository name
        IMAGE_TAG  = "v${BUILD_NUMBER}"   // e.g. v1, v2, v3...
    }

    tools {
        jdk 'JDK-17'
        maven 'Maven_3.9'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                git branch: 'main',
                    url: 'https://github.com/sneghalathaterraform/hello-sample-ec2.git'
            }
        }

        stage('Build JAR') {
            steps {
                echo '⚙️ Building Spring Boot JAR...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh """
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '🚀 Pushing image to Docker Hub...'
                sh """
                    echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Deploy Container') {
            steps {
                echo '▶️ Running Docker container...'
                sh """
                    # Stop and remove old container if running
                    docker stop springboot-app || true
                    docker rm springboot-app   || true

                    # Run new container
                    docker run -d \
                        --name springboot-app \
                        -p 8080:8080 \
                        ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
        always {
            // Clean up local Docker images to save disk space
            sh 'docker image prune -f'
        }
    }
}