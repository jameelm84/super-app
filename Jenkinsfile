pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy') // הגדרת משתנה לתעודות AWS
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/jameelm84/super-app.git'
            }
        }
        stage('Verify Dockerfile') {
            steps {
                script {
                    if (!fileExists('node/Dockerfile')) {
                        error "Dockerfile not found in node directory"
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${env.REPO_NAME}:${env.BUILD_NUMBER}", "node/")
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
        stage('Archive') {
            steps {
                script {
                    sh 'zip -r my-key.zip .'
                }
            }
        }
        stage('Upload to S3') {
            steps {
                script {
                    sh 'aws s3 cp my-key.zip s3://bucket-jenkins-jameel/jenkins/my-key.zip --region eu-central-1'
                }
            }
        }
        stage('Deploy to AWS CodeDeploy') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    script {
                        sh """
                        aws deploy create-deployment \
                        --application-name supper-app-jameel \
                        --deployment-group-name jameel-app-dg \
                        --s3-location bucket=bucket-jenkins-jameel,bundleType=zip,key=jenkins/my-key.zip \
                        --region eu-central-1
                        """
                    }
                }
            }
        }
    }
}
