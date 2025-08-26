pipeline {
    agent any

    environment {
        REGISTRY = "localhost:5000"     // registre local
        IMAGE_NAME = "app"
        IMAGE_TAG = "latest"            // tu peux utiliser BUILD_NUMBER si tu veux versionner
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'http://gitea_gitea:3000/reda/swarm.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t $REGISTRY/$IMAGE_NAME:$IMAGE_TAG .
                    """
                }
            }
        }

        stage('Push Image to Registry') {
            steps {
                script {
                    sh """
                        docker push $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Deploy to Swarm') {
            steps {
                script {
                    sh """
                        docker service update --image $REGISTRY/$IMAGE_NAME:$IMAGE_TAG app_app || \
                        docker service create --name app_app --publish 8080:80 $REGISTRY/$IMAGE_NAME:$IMAGE_TAG
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement réussi !"
        }
        failure {
            echo "❌ Échec du pipeline"
        }
    }
}

