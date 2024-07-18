pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy')
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
        stage('Create AppSpec and Scripts') {
            steps {
                script {
                    writeFile file: 'appspec.yml', text: """
                    version: 0.0
                    os: linux
                    files:
                      - source: /
                        destination: /var/www/html/
                    hooks:
                      BeforeInstall:
                        - location: before_install.sh
                          timeout: 300
                          runas: root
                      AfterInstall:
                        - location: after_install.sh
                          timeout: 300
                          runas: root
                      ApplicationStop:
                        - location: stop_server.sh
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
                    """
                    writeFile file: 'before_install.sh', text: '''
                    #!/bin/bash
                    apt-get update
                    apt-get install -y docker-compose
                    '''
                    writeFile file: 'after_install.sh', text: '''
                    #!/bin/bash
                    echo "After Install step"
                    '''
                    writeFile file: 'stop_server.sh', text: '''
                    #!/bin/bash
                    docker-compose -f /var/www/html/docker-compose.yaml down
                    '''
                    writeFile file: 'start_server.sh', text: '''
                    #!/bin/bash
                    docker-compose -f /var/www/html/docker-compose.yaml up -d
                    '''
                    writeFile file: 'validate_service.sh', text: '''
                    #!/bin/bash
                    echo "Validate Service step"
                    '''
                }
            }
        }
        stage('Create Deployment Package') {
            steps {
                script {
                    sh 'zip -r my-key.zip *'
                }
            }
        }
        stage('Upload to S3') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    s3Upload(bucket: 'bucket-jenkins-jameel', path: 'jenkins/', file: 'my-key.zip')
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
