pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'Github', url: 'https://github.com/jameelm84/super-app.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.REPO_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        docker.image("${env.REPO_NAME}:${env.BUILD_NUMBER}").push()
                    }
                }
            }
        }
    }
}
