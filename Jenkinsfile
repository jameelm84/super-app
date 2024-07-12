pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Node.js App') {
            steps {
                script {
                    docker.image('node:17-slim').inside {
                        sh 'cd nodes && npm install && npm test'
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("jameelm/supper-app:node", "-f nodes/Dockerfile nodes")
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        docker.image('jameelm/supper-app:node').push()
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
