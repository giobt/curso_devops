pipeline {
    agent {
        docker { image 'gradle:7.2-jdk11' }
    }
    stages {
        stage('Build') {
            steps {
                sh 'gradle --version'
            }
        }
    }
}