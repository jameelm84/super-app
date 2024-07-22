pipeline {
    agent any

    environment {
        S3_BUCKET = 'bucket-jenkins-jameel/jenkins'
        APP_NAME = 'super-app'
        REPO_URL = 'https://github.com/jameelm84/super-app.git'
        REGION = 'eu-central-1'
        DEPLOYMENT_GROUP = 'jameel-app-dg'
        CODEDEPLOY_APPLICATION = 'supper-app-jameel'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        REPO_NAME = 'jameelm/supper-app'
        AWS_CREDENTIALS = credentials('aws-codedeploy')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${REPO_URL}", branch: 'main'
            }
        }
        
        stage('Build Deployment Package') {
            steps {
                script {
                    sh '''
                    mkdir -p ${APP_NAME}/scripts
                    cp Jenkinsfile README.md appspec.yml docker-compose.yaml ${APP_NAME}/
                    cp -r node php scripts ${APP_NAME}/
                    cd ${APP_NAME}
                    zip -r deployment-package.zip Jenkinsfile README.md appspec.yml docker-compose.yaml node php scripts
                    '''
                }
            }
        }
        
        stage('Upload to S3') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-codedeploy']]) {
                    script {
                        sh '''
                        echo "Configuring AWS CLI..."
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $REGION
                        echo "AWS CLI Configuration:"
                        aws configure list

                        echo "Uploading to S3..."
                        aws s3 cp ${APP_NAME}/deployment-package.zip s3://${S3_BUCKET}/deployment-package.zip
                        echo "Upload complete."
                        '''
                    }
                }
            }
        }

        stage('Deploy to CodeDeploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-codedeploy']]) {
                    script {
                        def deploymentId = sh(
                            script: """
                            aws deploy create-deployment \
                                --application-name ${CODEDEPLOY_APPLICATION} \
                                --deployment-group-name ${DEPLOYMENT_GROUP} \
                                --s3-location bucket=${S3_BUCKET},bundleType=zip,key=deployment-package.zip \
                                --region ${REGION} \
                                --output text --query 'deploymentId'
                            """,
                            returnStdout: true
                        ).trim()
                        
                        echo "Deployment started with ID: ${deploymentId}"
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
