pipeline {
    agent any

    stages {
        stage('Build Docker image') {
            steps {
                sh '''
                    cd app/code
                    docker build -t app:latest .
                '''
            }
        }

        stage('Tag & Push Docker image') {
            steps {
                sh '''
                    cd app/code
                    docker tag app:latest localhost:5000/eadn-repo/app:latest
                    docker login localhost:5000 -u admin -p admin
                    docker push localhost:5000/eadn-repo/app:latest
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    cd app
                    docker stack deploy -c app-stack.yml app
                '''
            }
        }
    }
}