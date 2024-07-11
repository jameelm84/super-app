pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/jameelm84/super-app.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                script {
                    docker.build('super-app', '-f nodes/Dockerfile nodes')
                    docker.build('php-app', '-f php/Dockerfile php')
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.image('super-app').inside {
                        sh 'npm test' // Assuming you have tests defined
                    }
                    docker.image('php-app').inside {
                        sh 'php -r "echo \'Tests run\';"' // Dummy test command
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        docker.image('super-app').push('latest')
                        docker.image('php-app').push('latest')
                    }
                }
            }
        }
    }

    post {
        always {
            node {
                cleanWs()
            }
        }
    }
}
