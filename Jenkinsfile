pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dockerImage = docker.build "gabalconi/curso_devops"
            }
        }
        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry('', 'credentials-id') {
                        dockerImage.push("v_$BUILD_NUMER")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }
}