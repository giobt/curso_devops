pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build "gabalconi/curso_devos"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    docker.withRegistry( '', '08c01d29-529b-46a7-9737-ddc5e1a8f648' ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}