pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        S3_BUCKET = 'bucket-jenkins-jameel'
        S3_PATH = 'jenkins/deployment-package.zip'
        DEPLOYMENT_GROUP = 'jameel-app-dg-dg'
        CODEDEPLOY_APPLICATION = 'supper-app-jameel'
        AWS_REGION = 'eu-central-1'
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
                    sh """
                    echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                    docker-compose push
                    """
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
                    sh """
                    aws s3 cp deployment-package.zip s3://$S3_BUCKET/$S3_PATH
                    """
                }
            }
        }

        stage('Deploy with CodeDeploy') {
            steps {
                script {
                    sh """
                    aws deploy create-deployment --application-name $CODEDEPLOY_APPLICATION --deployment-group-name $DEPLOYMENT_GROUP --s3-location bucket=$S3_BUCKET,key=$S3_PATH,bundleType=zip --region $AWS_REGION --output text --query deploymentId
                    """
                }
            }
        }
    }
}
