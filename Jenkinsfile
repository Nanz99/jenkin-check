pipeline {
    agent any

    environment {
        // Docker environment variables
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'anhnhut'  // Publicly loggable value
        // DOCKERHUB_PASSWORD should be securely stored in Jenkins credentials
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
                sh 'npm install'

                echo 'Building the ReactJS application...'
                sh 'npm run build'
                echo 'Build completed successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                // Log the Docker image name for debugging
                echo "Docker Image: ${DOCKER_IMAGE}"

                // Build the Docker image using shell commands
                sh "docker build -t ${DOCKER_IMAGE}:latest ."
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
                        // Log in to DockerHub securely
                        sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
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
                sh '''
                docker stop react-app || true
                docker rm react-app || true
                docker run -d -p 80:80 --name react-app ${DOCKER_IMAGE}:latest
                '''
                echo 'Application deployed successfully.'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up Docker resources...'
            sh 'docker system prune -f'
            echo 'Pipeline completed.'
        }
    }
}
