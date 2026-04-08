pipeline {
    agent any

    environment {
        IMAGE_NAME = "helloapp:v1"
        CONTAINER_NAME = "helloapp-container"
        PORT = "8082"   // EC2 public port for access
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from GitHub
                git branch: 'main', url: 'https://github.com/sneghalathaterraform/hello-sample-ec2'
            }
        }

        stage('Build WAR') {
            steps {
                // Compile and package with Maven
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                // Build Docker image using Dockerfile in repo
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Docker Run') {
            steps {
                // Stop old container if exists
                sh "docker rm -f ${CONTAINER_NAME} || true"
                // Run new container mapping EC2 port
                sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:8080 ${IMAGE_NAME}"
            }
        }
    }

    post {
        success {
            echo "Deployment Successful! Access at http://<EC2-PUBLIC-IP>:${PORT}/helloapp"
        }
        failure {
            echo "Build or Deployment Failed!"
        }
    }
}
