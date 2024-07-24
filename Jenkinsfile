pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy')
        S3_BUCKET = 'bucket-jenkins-jameel'
        S3_PATH = 'jenkins/deployment-package.zip'
        DEPLOYMENT_GROUP = 'jameel-app-dg-dg'
        CODEDEPLOY_APPLICATION = 'supper-app-jameel'
    }

    stages {
        stage('Clone repository') {
            steps {
                git branch: 'main', url: 'https://github.com/jameelm84/super-app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    cd php/
                    dockerImage = docker.build("${REPO_NAME}:latest")
                }
            }
        }

        stage('Push Docker image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Upload deployment package to S3') {
            steps {
                sh 'zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts'
                withAWS(credentials: AWS_CREDENTIALS, region: 'eu-central-1') {
                    s3Upload(bucket: "${S3_BUCKET}", path: "${S3_PATH}", file: 'deployment-package.zip')
                }
            }
        }

        stage('Deploy to EC2 with CodeDeploy') {
            steps {
                withAWS(credentials: AWS_CREDENTIALS, region: 'eu-central-1') {
                    sh "aws deploy create-deployment --application-name ${CODEDEPLOY_APPLICATION} --deployment-group-name ${DEPLOYMENT_GROUP} --s3-location bucket=${S3_BUCKET},key=${S3_PATH},bundleType=zip --region eu-central-1 --output text --query deploymentId"
                }
            }
        }
    }
}
