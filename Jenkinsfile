pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy')
        S3_BUCKET = 'bucket-jenkins-jameel'
        DEPLOYMENT_GROUP = 'jameel-dg-dg'
        CODEDEPLOY_APPLICATION = 'supper-app-jameel'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/jameelm84/super-app.git'
            }
        }
        stage('Package Application') {
            steps {
                script {
                    sh 'zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts'
                }
            }
        }
        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    s3Upload(bucket: "${S3_BUCKET}", file: 'deployment-package.zip', path: 'jenkins/deployment-package.zip')
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    script {
                        sh """
                        aws deploy create-deployment \
                            --application-name ${CODEDEPLOY_APPLICATION} \
                            --deployment-group-name ${DEPLOYMENT_GROUP} \
                            --s3-location bucket=${S3_BUCKET}/jenkins,bundleType=zip,key=deployment-package.zip \
                            --deployment-config-name CodeDeployDefault.AllAtOnce \
                            --region eu-central-1
                        """
                    }
                }
            }
        }
    }
}
