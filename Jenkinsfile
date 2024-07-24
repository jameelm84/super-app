
        stage('Upload to S3') {
            steps {
                withCredentials([string(credentialsId: 'aws-codedeploy', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'aws-codedeploy', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $REGION
                        aws s3 cp ${APP_NAME}/deployment-package.zip s3://${S3_BUCKET}/deployment-package.zip
                        '''
                    }
                }
	@@ -52,8 +57,7 @@ pipeline {

        stage('Deploy to CodeDeploy') {
            steps {
                withCredentials([string(credentialsId: 'aws-codedeploy', variable: 'AWS_ACCESS_KEY_ID'),
                                 string(credentialsId: 'aws-codedeploy', variable: 'AWS_SECRET_ACCESS_KEY')]) {
                    script {
                        def deploymentId = sh(
                            script: """
