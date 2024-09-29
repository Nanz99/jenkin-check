pipeline {
    agent any

    environment {
        // Docker environment variables
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'anhnhut'
        // DOCKERHUB_PASSWORD should be stored in Jenkins Credentials securely
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository from GitHub...'
                git branch: 'main', url: 'https://github.com/Nanz99/jenkin-check.git'
                echo 'Repository cloned successfully.'
            }
        }

        stage('Build Application') {
            steps {
                echo 'Installing dependencies...'
                bat 'npm install'

                echo 'Building the ReactJS application...'
                bat 'npm run build'
                echo 'Build completed successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                // Building the Docker image using a batch command
                bat "docker build -t ${DOCKER_IMAGE} ."
                echo 'Docker image built successfully.'
            }
        }

        stage('Docker Login and Push') {
            steps {
                echo 'Logging into DockerHub...'

                // Secure DockerHub credentials using Jenkins Credentials
                withCredentials([string(credentialsId: 'DOCKERHUB_PASSWORD', variable: 'DOCKERHUB_PASSWORD')]) {
                    script {
                        // Using bat to run Docker login and push commands on Windows
                        bat """
                        echo %DOCKERHUB_PASSWORD% | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }

                echo 'Docker image pushed to DockerHub successfully.'
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying the application...'
                // Stopping, removing old container, and running a new one
                bat '''
                docker stop react-app || exit 0
                docker rm react-app || exit 0
                docker run -d -p 80:80 --name react-app ${DOCKER_IMAGE}:latest
                '''
                echo 'Application deployed successfully.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker resources...'
            bat 'docker system prune -f'
            echo 'Pipeline completed.'
        }
    }
}
