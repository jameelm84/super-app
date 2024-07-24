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
                    sh 'docker-compose build'
                }
            }
        }

        stage('Push Docker image to DockerHub') {
            steps {
                script {
                    sh 'docker-compose push'
                }
            }
        }

        stage('Create deployment package') {
            steps {
                script {
                    sh 'zip -r deployment-package.zip docker-compose.yaml appspec.yml scripts'
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    withAWS(credentials: AWS_CREDENTIALS, region: 'eu-central-1') {
                        s3Upload(bucket: "${S3_BUCKET}", path: "${S3_PATH}", file: 'deployment-package.zip')
                    }
                }
            }
        }

        stage('Deploy with CodeDeploy') {
            steps {
                script {
                    withAWS(credentials: AWS_CREDENTIALS, region: 'eu-central-1') {
                        sh "aws deploy create-deployment --application-name ${CODEDEPLOY_APPLICATION} --deployment-group-name ${DEPLOYMENT_GROUP} --s3-location bucket=${S3_BUCKET},key=${S3_PATH},bundleType=zip --region eu-central-1 --output text --query deploymentId"
                    }
                }
            }
        }
    }
}
