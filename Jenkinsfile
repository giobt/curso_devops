pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                dockerImage = docker.build 'gabalconi/curso_devos:from_jenkins'
            }
        }
        
    }
}