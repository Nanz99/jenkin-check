pipeline {
    agent any

    environment {
        // Biến môi trường cho Docker
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'anhnhut'
        DOCKERHUB_PASSWORD = '0830.9900.1111' // Không khuyến khích lưu thông tin đăng nhập ở đây.
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository from GitHub...'
                // Clone mã nguồn từ GitHub
                git branch: 'main', url: 'https://github.com/Nanz99/jenkin-check.git'
                echo 'Repository cloned successfully.'
            }
        }

        stage('Build Application') {
            steps {
                echo 'Installing dependencies...'
                // Cài đặt các dependencies của ứng dụng ReactJS
                sh 'npm install'

                echo 'Building the ReactJS application...'
                // Build ứng dụng ReactJS
                sh 'npm run build'
                echo 'Build completed successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                // Build Docker image từ Dockerfile
                script {
                    def app = docker.build("${DOCKER_IMAGE}")
                }
                echo 'Docker image built successfully.'
            }
        }

        stage('Docker Login and Push') {
            steps {
                echo 'Logging into DockerHub...'
                // Đăng nhập DockerHub và đẩy Docker image lên
                script {
                    sh '''
                    echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                    docker push ${DOCKER_IMAGE}:latest
                    '''
                }
                echo 'Docker image pushed to DockerHub successfully.'
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying the application...'
                // Dừng container cũ (nếu có) và chạy container mới từ Docker image
                script {
                    sh '''
                    docker stop react-app || true
                    docker rm react-app || true
                    docker run -d -p 80:80 --name react-app ${DOCKER_IMAGE}:latest
                    '''
                }
                echo 'Application deployed successfully.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker resources...'
            // Clean up Docker để giải phóng bộ nhớ sau mỗi build
            sh 'docker system prune -f'

            echo 'Pipeline completed.'
        }
    }
}
