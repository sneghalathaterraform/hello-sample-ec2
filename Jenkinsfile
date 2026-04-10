pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')      // secret text credential ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        DOCKERHUB_CREDENTIALS = credentials('docker_aws_login')
        AWS_REGION      = 'us-east-1'
        ECR_REGISTRY    = '908340073825.dkr.ecr.us-east-1.amazonaws.com'
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

        stage('Authenticate to ECR') {
            steps {
                    sh """
                        aws ecr get-login-password --region ${AWS_REGION} | \
                        docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    """
            }
        }

        stage('Build Docker Image') {
            steps {
                    sh """
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${ECR_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                    """
            }
        }


        stage('Deploy Container') {
            steps {
                echo '▶️ Running Docker container...'
                sh """
                    # Stop and remove old container if running
                    docker stop helloapp || true
                    docker rm helloapp   || true

                    # Run new container
                    docker run -d \
                        --name helloapp \
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