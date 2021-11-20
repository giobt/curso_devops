pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build "gabalconi/curso_devops"
                }
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('', 'b7154fd5-7b08-424a-bb4c-8a4f8a6d0011') {
                        dockerImage.push("$BUILD_ID")
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    withAWS(region: 'eu-west-2', credentials: 'd91f7e36-e9b6-48eb-af4d-a16e219e0a03') {
                        sh "aws ecs register-task-definition \
                            --family first-run-task-definition \
                            --cli-input-json file://taskdef.json"

                        sh "aws ecs update-service --service helloworld-service --cluster helloworld --force-new-deployment"
                    }
                }
            }
        }
    }
}