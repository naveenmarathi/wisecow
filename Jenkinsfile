pipeline {
    agent any

    environment {
        IMAGE_NAME = "naveenm323/wisecow-app"
        GIT_SHA = "${env.GIT_COMMIT}"   // Commit SHA for unique tagging
    }

    stages {
        stage("Checkout Code") {
            steps {
                echo " Checking out source code"
                checkout scm
            }
        }

        stage("Docker Login") {
            steps {
                echo " Logging into DockerHub"
                sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
            }
        }

        stage("Build & Push Docker Image") {
            steps {
                echo " Building and pushing Docker image"
                sh """
                    docker build -t $IMAGE_NAME:latest -t $IMAGE_NAME:$GIT_SHA .
                    docker push $IMAGE_NAME:latest
                    docker push $IMAGE_NAME:$GIT_SHA
                """
            }
        }

        stage("Setup Kubeconfig") {
            steps {
                echo "⚙️ Setting up kubeconfig"
                sh """
                    mkdir -p \$HOME/.kube
                    echo \$KUBE_CONFIG_DATA | base64 -d > \$HOME/.kube/config
                """
            }
        }

        stage("Deploy to Kubernetes") {
            steps {
                echo " Deploying to Kubernetes"
                sh """
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                """
            }
        }

        stage("Verify Rollout") {
            steps {
                echo " Verifying Deployment rollout"
                sh "kubectl rollout status deployment/wisecow-deployment --timeout=60s"
            }
        }
    }
}
