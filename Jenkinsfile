pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    environment {
        DOCKER_REPO = 'sirnnadi1/wildlife-app'
        IMAGE_TAG   = "build-${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_REPO}:${IMAGE_TAG} .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker rm -f wildlife-test || true'
                sh 'docker run -d --name wildlife-test ${DOCKER_REPO}:${IMAGE_TAG}'
                sh 'sleep 5'
                sh '''
                    IP=$(docker inspect -f \'{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' wildlife-test)
                    curl -f http://$IP:4173/health || exit 1
                '''
                sh 'docker stop wildlife-test && docker rm wildlife-test'
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'wildlife-app',
                    usernameVariable: 'DH_USER',
                    passwordVariable: 'DH_PASS'
                )]) {
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    sh 'docker push ${DOCKER_REPO}:${IMAGE_TAG}'
                    sh 'docker logout'
                }
            }
        }

    }

    post {
        success {
            echo "Pipeline succeeded! Image pushed: ${DOCKER_REPO}:${IMAGE_TAG}"
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            sh 'docker rmi ${DOCKER_REPO}:${IMAGE_TAG} || true'
            cleanWs()
        }
    }
}
