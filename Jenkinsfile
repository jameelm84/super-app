pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERHUB_REPO = "jameelm/supper-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jameelm84/super-app.git'
            }
        }

        stage('Build Node Image') {
            steps {
                script {
                    docker.build("${DOCKERHUB_REPO}:node", "-f nodes/Dockerfile nodes")
                }
            }
        }

        stage('Build PHP Image') {
            steps {
                script {
                    docker.build("${DOCKERHUB_REPO}:php", "-f php/Dockerfile php")
                }
            }
        }

        stage('Push Images to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                        docker.image("${DOCKERHUB_REPO}:node").push()
                        docker.image("${DOCKERHUB_REPO}:php").push()
                    }
                }
            }
        }
    }
}
