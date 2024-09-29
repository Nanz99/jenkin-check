pipeline {
    agent any

    environment {
        // Docker environment variables
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'anhnhut'
        // Do not store sensitive information directly; use Jenkins credentials
        // DOCKERHUB_PASSWORD should be stored in Jenkins Credentials, not here
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository from GitHub...'
                // Clone the source code from GitHub
                git branch: 'main', url: 'https://github.com/Nanz99/jenkin-check.git'
                echo 'Repository cloned successfully.'
            }
        }

        stage('Build Application') {
            steps {
                echo 'Installing dependencies...'
                // Use 'bat' for Windows batch commands
                bat 'npm install'

                echo 'Building the ReactJS application...'
                bat 'npm run build'
                echo 'Build completed successfully.'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the Docker image...'
                script {
                    // Ensure Docker is running and build the image
                    def app = docker.build("${DOCKER_IMAGE}")
                }
                echo 'Docker image built successfully.'
            }
        }

        stage('Docker Login and Push') {
            steps {
                echo 'Logging into DockerHub...'
                // Secure DockerHub credentials using Jenkins Credentials
                withCredentials([string(credentialsId: 'DOCKERHUB_PASSWORD', variable: 'DOCKERHUB_PASSWORD')]) {
                    script {
                        bat '''
                        echo %DOCKERHUB_PASSWORD% | docker login -u %DOCKERHUB_USERNAME% --password-stdin
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
                script {
                    // Deploy the application by stopping and removing old containers and running a new one
                    bat '''
                    docker stop react-app || exit 0
                    docker rm react-app || exit 0
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
            // Cleanup Docker system to free up space
            bat 'docker system prune -f'

            echo 'Pipeline completed.'
        }
    }
}
