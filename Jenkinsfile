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
        stage('Prepare AppSpec') {
            steps {
                writeFile file: 'appspec.yml', text: '''
                version: 0.0
                os: linux
                files:
                  - source: node/Dockerfile
                    destination: /var/www/html/
                  - source: node/package.json
                    destination: /var/www/html/
                  - source: node/server.js
                    destination: /var/www/html/
                  - source: php
                    destination: /var/www/html/php
                  - source: docker-compose.yaml
                    destination: /var/www/html/
                hooks:
                  ApplicationStop:
                    - location: stop_server.sh
                      timeout: 300
                      runas: root
                  BeforeInstall:
                    - location: install_dependencies.sh
                      timeout: 300
                      runas: root
                  ApplicationStart:
                    - location: start_server.sh
                      timeout: 300
                      runas: root
                  ValidateService:
                    - location: validate_service.sh
                      timeout: 300
                      runas: root
                '''
                writeFile file: 'stop_server.sh', text: '''
                #!/bin/bash
                docker-compose -f /var/www/html/docker-compose.yaml down
                '''
                writeFile file: 'install_dependencies.sh', text: '''
                #!/bin/bash
                sudo apt update
                sudo apt install -y docker-compose
                cd /var/www/html
                docker-compose -f docker-compose.yaml build
                '''
                writeFile file: 'start_server.sh', text: '''
                #!/bin/bash
                cd /var/www/html
                docker-compose -f docker-compose.yaml up -d
                '''
                writeFile file: 'validate_service.sh', text: '''
                #!/bin/bash
                curl -Is http://localhost:3000 | head -n 1
                '''
                sh 'zip -r my-key.zip appspec.yml stop_server.sh install_dependencies.sh start_server.sh validate_service.sh node php docker-compose.yaml'
                sh 'aws s3 cp my-key.zip s3://bucket-jenkins-jameel/jenkins/'
            }
        }
        stage('Deploy to AWS CodeDeploy') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    script {
                        sh '''
                        aws deploy create-deployment \
                        --application-name supper-app-jameel \
                        --deployment-group-name jameel-app-dg \
                        --s3-location bucket=bucket-jenkins-jameel,bundleType=zip,key=jenkins/my-key.zip \
                        --region eu-central-1
                        '''
                    }
                }
            }
        }
    }
}
