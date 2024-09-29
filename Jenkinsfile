pipeline {
    agent any

    environment {
        // Docker environment variables
        DOCKER_IMAGE = 'anhnhut/react-app'
        DOCKERHUB_USERNAME = 'iamanhnhut.0101@gmail.com'  // Not secure! For demonstration only.
        DOCKERHUB_PASSWORD = '0830.9900.1111'  // Not secure! For demonstration only.
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

                // Login using the environment variable for the DockerHub password on Windows
                bat """
                echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin
                docker push ${DOCKER_IMAGE}:latest
                """

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
