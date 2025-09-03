pipeline {
    agent any
    
    environment {
        REGISTRY = "localhost:5000"
        IMAGE_NAME = "eadn-repo/app"
        TAG = "1.0"
        STACK_NAME = "app"
    }
    
    stages {
        stage('Cleanup Previous Image') {
            steps {
                script {
                    // Suppression de l'image précédente si elle existe
                    sh '''
                        docker rmi app:1.0 || true
                        docker rmi ${REGISTRY}/${IMAGE_NAME}:${TAG} || true
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                dir('eadn/app/code') {
                    sh 'docker build -t app:${TAG} .'
                }
            }
        }
        
        stage('Tag and Push Image') {
            steps {
                script {
                    sh """
                        docker tag app:${TAG} ${REGISTRY}/${IMAGE_NAME}:${TAG}
                        docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
                    """
                }
            }
        }
        
        stage('Deploy Stack') {
            steps {
                dir('eadn/app') {
                    script {
                        // Suppression du service existant silencieusement
                        sh 'docker service rm ${STACK_NAME}_app || true'
                        
                        // Déploiement de la stack
                        sh 'docker stack deploy -c app-stack.yml ${STACK_NAME}'
                    }
                }
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline exécutée avec succès!'
            echo '📦 Image docker buildée et poussée vers le registry'
            echo '🚀 Application déployée avec Docker Stack'
        }
        failure {
            echo '❌ Pipeline a échoué'
            slackSend channel: '#jenkins', message: "Échec du pipeline: ${currentBuild.fullDisplayName}"
        }
        always {
            echo '🧹 Nettoyage des ressources temporaires'
            cleanWs()
        }
    }
}