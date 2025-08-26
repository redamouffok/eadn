pipeline {
    agent any

    environment {
        REGISTRY = "localhost:5000"
        IMAGE_NAME = "eadn/app"
        IMAGE_TAG = "1.0"
        STACK_FILE = "EADN/app/app-stack.yml"
        SERVICE_NAME = "app_app"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'http://gitea_gitea:3000/reda/swarm.git'
            }
        }

        stage('Build & Push Image') {
            steps {
                dir('EADN/app/code') {
                    script {
                        sh """
                            # supprimer ancienne image si elle existe
                            docker rmi app:${IMAGE_TAG} || true

                            # build nouvelle image
                            docker build -t app:${IMAGE_TAG} .

                            # tag vers le registre
                            docker tag app:${IMAGE_TAG} ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}

                            # push au registre
                            docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                        """
                    }
                }
            }
        }

        stage('Deploy Stack') {
            steps {
                dir('EADN/app') {
                    script {
                        sh """
                            # supprimer ancien service
                            docker service rm ${SERVICE_NAME} || true

                            # déployer la stack
                            docker stack deploy -c ${STACK_FILE} app
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Build & déploiement terminés avec succès"
        }
        failure {
            echo "❌ Le pipeline a échoué"
        }
    }
}
        
