pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jameelm84/super-app.git'
            }
        }
        stage('Build') {
            steps {
                sh 'docker-compose -f docker-compose.yaml build'
            }
        }
        stage('Test') {
            steps {
                sh 'docker-compose -f docker-compose.yaml up -d'
                sh 'docker-compose -f docker-compose.yaml down'
            }
        }
        stage('Package') {
            steps {
                sh '''
                mkdir -p deploy
                cp -r Jenkinsfile README.md appspec.yml docker-compose.yaml deploy/
                cp -r node deploy/node
                cp -r php deploy/php
                cp -r scripts deploy/scripts
                cd deploy
                zip -r deployment-package.zip *
                '''
            }
        }
        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'jenkins-aws-credentials', region: 'eu-central-1') {
                    s3Upload(bucket: 'bucket-jenkins-jameel', path: 'jenkins/deployment-package.zip', file: 'deploy/deployment-package.zip')
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def deployment = sh(script: '''
                    aws deploy create-deployment --application-name supper-app-jameel --deployment-config-name CodeDeployDefault.OneAtATime --deployment-group-name <YourDeploymentGroupName> --s3-location bucket=bucket-jenkins-jameel,key=jenkins/deployment-package.zip,bundleType=zip
                    ''', returnStdout: true).trim()
                    echo "Deployment ID: ${deployment}"
                }
            }
        }
    }
}
