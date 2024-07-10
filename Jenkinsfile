pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jameelm84/super-app.git'
            }
        }
        
        stage('Build') {
            steps {
                script {
                    docker.build('super-app', '-f nodes/Dockerfile .')
                    docker.build('php-app', '-f php/Dockerfile .')
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
            cleanWs()
        }
    }
}
