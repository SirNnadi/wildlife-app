pipeline {
    agent any

    tools {
        nodejs 'NodeJS-24'
    }

    environment {
        ECR_REGISTRY = '068704208379.dkr.ecr.us-east-1.amazonaws.com'
        ECR_REPO     = 'wildlife-app'
        AWS_REGION   = 'us-east-1'
        CLUSTER_NAME = 'wildlife-eks-prod'
        HELM_RELEASE = 'wildlife-explorer'
        HELM_CHART   = 'helm/wildlife-explorer'
        HELM_VALUES  = 'helm/wildlife-explorer/env/values-prod.yaml'
        K8S_NAMESPACE = 'production'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.IMAGE_TAG = sh(script: 'git rev-parse --short=7 HEAD', returnStdout: true).trim()
                    env.IMAGE_URI = "${ECR_REGISTRY}/${ECR_REPO}:${env.IMAGE_TAG}"
                }
            }
        }

        stage('Install & Test') {
            steps {
                sh 'npm ci'
                sh 'npm test'
            }
        }

        stage('Build & Push to ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        aws ecr get-login-password --region $AWS_REGION | \
                            docker login --username AWS --password-stdin $ECR_REGISTRY

                        docker buildx create --use --name multiarch 2>/dev/null || docker buildx use multiarch

                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t $IMAGE_URI \
                            --push .
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY'
                    sh 'docker rm -f wildlife-test || true'
                    sh 'docker run -d --name wildlife-test --platform linux/amd64 $IMAGE_URI'
                    sh 'sleep 5'
                    sh '''
                        IP=$(docker inspect -f \'{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' wildlife-test)
                        curl -f http://$IP:4173/health || exit 1
                    '''
                    sh 'docker stop wildlife-test && docker rm wildlife-test'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh '''
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                        helm upgrade --install $HELM_RELEASE $HELM_CHART \
                            -f $HELM_VALUES \
                            --namespace $K8S_NAMESPACE \
                            --set image.tag=$IMAGE_TAG \
                            --wait --timeout 3m
                    '''
                }
            }
        }

    }

    post {
        success {
            echo "Deployed ${env.IMAGE_URI} to ${CLUSTER_NAME}"
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            sh 'docker rmi $IMAGE_URI || true'
            cleanWs()
        }
    }
}
