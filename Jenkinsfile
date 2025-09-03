pipeline {
    agent any

    environment {
        REGISTRY_URL = "localhost:5000"
        REGISTRY_REPO = "eadn-repo"
        IMAGE_NAME = "app"
        FULL_IMAGE = "${env.REGISTRY_URL}/${env.REGISTRY_REPO}/${env.IMAGE_NAME}"
        REG_USER = "admin"       // ⚠️ Mets ici ton vrai user Registry
        REG_PASS = "admin"    // ⚠️ Mets ici ton vrai mot de passe Registry
        APP_VERSION = "${env.BUILD_NUMBER}"   // version auto avec numéro de build
    }
    
    triggers {
        giteaPush()
    }
    
    stages {
        stage('Build Docker image..') {
            steps {
                sh '''
                    cd app/code
                    docker build -t ${FULL_IMAGE}:${APP_VERSION} -t ${FULL_IMAGE}:latest .
                '''
            }
        }

        stage('Login & Push Docker image') {
            steps {
                sh '''
                    echo "${REG_PASS}" | docker login ${REGISTRY_URL} -u "${REG_USER}" --password-stdin
                    docker push ${FULL_IMAGE}:${APP_VERSION}
                    docker push ${FULL_IMAGE}:latest
                '''
            }
        }

        stage('Deploy Stack') {
            steps {
                sh '''
                    cd app
                    docker stack deploy -c app-stack.yml ${IMAGE_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement réussi : ${FULL_IMAGE}:${APP_VERSION} + latest"
        }
        failure {
            echo "❌ Le pipeline a échoué"
        }
    }
}
