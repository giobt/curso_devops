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
        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry('', 'b7154fd5-7b08-424a-bb4c-8a4f8a6d0011') {
                        dockerImage.push("v_$BUILD_NUMER")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }
}