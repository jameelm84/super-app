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
                    try {
                        docker.build('super-app', '-f nodes/Dockerfile nodes')
                        docker.build('php-app', '-f php/Dockerfile php')
                    } catch (Exception e) {
                        echo "Build failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    try {
                        docker.image('super-app').inside {
                            sh 'npm test' // Assuming you have tests defined
                        }
                        docker.image('php-app').inside {
                            sh 'php -r "echo \'Tests run\';"' // Dummy test command
                        }
                    } catch (Exception e) {
                        echo "Test failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', DOCKERHUB_CREDENTIALS) {
                            docker.image('super-app').push('latest')
                            docker.image('php-app').push('latest')
                        }
                    } catch (Exception e) {
                        echo "Push to DockerHub failed: ${e.message}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                node {
                    if (fileExists(env.WORKSPACE)) {
                        deleteDir()
                    }
                }
            }
        }
    }
}
