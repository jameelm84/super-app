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
                    docker-compose build
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
                script {
                    sh """
                    # Remove any existing deployment package
                    rm -f deployment-package.zip

                    # Create deployment package
                    zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts

                    # Verify the content of the deployment package
                    echo "Contents of the deployment package:"
                    unzip -l deployment-package.zip

                    # Upload to S3
                    aws s3 cp deployment-package.zip s3://bucket-jenkins-jameel/jenkins/deployment-package.zip
                    """
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
