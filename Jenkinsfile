pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build 'gabalconi/curso_devos:from_jenkins'
                }
            }
        }
    }
}