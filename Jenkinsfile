pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/jameelm84/super-app.git'
            }
        }
        stage('Build and Push Node Image') {
            steps {
                script {
                    docker.withRegistry('', env.DOCKERHUB_CREDENTIALS) {
                        def nodeApp = docker.build("jameelm/supper-app:node", "nodes/")
                        nodeApp.push()
                    }
                }
            }
        }
        stage('Build and Push PHP Image') {
            steps {
                script {
                    docker.withRegistry('', env.DOCKERHUB_CREDENTIALS) {
                        def phpApp = docker.build("jameelm/supper-app:php", "php/")
                        phpApp.push()
                    }
                }
            }
        }
    }
}
