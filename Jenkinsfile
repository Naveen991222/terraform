pipeline {
    agent any

    stages {
        stage('Test Git') {
            steps {
                sh 'git --version'
                sh 'git ls-remote https://github.com/Naveen991222/terraform.git'
            }
        }
    }
}
