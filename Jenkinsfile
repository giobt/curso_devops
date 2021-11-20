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
        stage('Deplou') {
            steps {
                script {
                    withAWS(region: 'eu-west-2', credentials: 'd91f7e36-e9b6-48eb-af4d-a16e219e0a03') {
                        def taskdef = 'aws ecs describe-task-definition --task-definition ws ecs describe-task-definition --task-definition first-run-task-definition:1'

                        taskDefRegistry = readJSON text: sh(returnStdout: true, script:"aws ecs register-task-definition \
                            --task-role-arn <task-role-arn> \
                            --family <task-def-name> \
                            --network-mode awsvpc \
                            --requires-compatibilities EC2 FARGATE \
                            --cli-input-json file://taskdef.json"), returnPojo: true

                        def updateService = "aws ecs update-service --service <your-ecs-service-name> --cluster <your-cluster-name> --force-new-deployment"
                        def runUpdateService = sh(returnStdout: true, script: updateService)
                        def serviceStable = "aws ecs wait services-stable --service $internationalService --cluster $internationalCluster"
                        sh(returnStdout: true, script: serviceStable)
                    }
                }
            }
        }
    }
}