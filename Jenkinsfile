pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION = 'eu-central-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("supper-app:latest", "./node")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Prepare Deployment Package') {
            steps {
                sh 'zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts'
            }
        }

        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'aws-credentials') {
                    s3Upload(bucket: 'bucket-jenkins-jameel', file: 'deployment-package.zip', path: 'jenkins/deployment-package.zip')
                }
            }
        }

        stage('Deploy to AWS CodeDeploy') {
            steps {
                withAWS(credentials: 'aws-credentials') {
                    sh '''
                    aws deploy create-deployment \
                        --application-name supper-app-jameel \
                        --deployment-group-name jameel-dg-dg \
                        --s3-location bucket=bucket-jenkins-jameel,bundleType=zip,key=jenkins/deployment-package.zip \
                        --region eu-central-1
                    '''
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
