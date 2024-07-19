pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy')  // שם האישורים ב-Jenkins
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
        stage('Prepare Deployment Package') {
            steps {
                withAWS(credentials: 'aws-codedeploy', region: 'eu-central-1') {
                    script {
                        sh """
                        zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts after_install.sh before_install.sh install_dependencies.sh start_server.sh stop_server.sh validate_service.sh
                        aws s3 cp deployment-package.zip s3://bucket-jenkins-jameel/jenkins/deployment-package.zip
                        """
                    }
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
                        --s3-location bucket=bucket-jenkins-jameel,bundleType=zip,key=jenkins/deployment-package.zip \
                        --region eu-central-1
                        """
                    }
                }
            }
        }
    }
}
