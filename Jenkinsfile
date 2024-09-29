pipeline {
    agent any

    environment {
        // Docker environment variables
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'anhnhut'  // Publicly loggable value
        // DOCKERHUB_PASSWORD should be stored securely in Jenkins credentials
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
                // Log the Docker image name for debugging
                echo "Docker Image: ${DOCKER_IMAGE}"

                // Build the Docker image using batch commands
                bat "docker build -t %DOCKER_IMAGE% ."
                echo 'Docker image built successfully.'
            }
        }

        stage('Docker Login and Push') {
            steps {
                echo 'Logging into DockerHub...'

                // Log the DockerHub username for debugging (non-sensitive)
                echo "DockerHub Username: ${DOCKERHUB_USERNAME}"

                // Secure DockerHub credentials using Jenkins Credentials
                withCredentials([string(credentialsId: 'DOCKERHUB_PASSWORD', variable: 'DOCKERHUB_PASSWORD')]) {
                    script {
                        // Mask the password for security and avoid plain-text output
                        echo "Logging in to DockerHub..."

                        // Log a masked password message (DO NOT log actual password)
                        echo "DockerHub Password is set (masked)"

                        // Log in and push the image using batch commands
                        bat '''
                        echo %DOCKERHUB_PASSWORD% | docker login -u %DOCKERHUB_USERNAME% --password-stdin
                        docker push %DOCKER_IMAGE%:latest
                        '''
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
                docker run -d -p 80:80 --name react-app %DOCKER_IMAGE%:latest
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
