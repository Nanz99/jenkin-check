pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Lấy code từ GitHub
                git branch: 'main', url: 'https://github.com/Nanz99/jenkin-check'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image từ Dockerfile
                script {
                    dockerImage = docker.build("jenkin-check")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                // Chạy container từ image đã build
                script {
                    dockerImage.run('-p 80:80')
                }
            }
        }
    }

    post {
        always {
            // Dọn dẹp container sau khi xong việc
            sh 'docker container prune -f'
        }
    }
}
