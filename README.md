# WiseCow Application Deployment

This repository contains the deployment files and instructions for deploying the WiseCow application in a Kubernetes cluster using Git, Jenkins, Docker, and Kubernetes.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Deployment Steps](#deployment-steps)
- [Configuration](#configuration)

## Overview

The WiseCow application is a simple web application. It provides to upload videos, audios, images and chat. This README provides guidance on deploying the WiseCow application in a Kubernetes cluster.

## Prerequisites

Before you begin, ensure you have the following installed:

- Git
- Jenkins
- Docker
- Kubernetes cluster (e.g., Minikube, AWS EKS, GKE)

## Deployment Steps

Follow these steps to deploy the WiseCow application:

1. Clone this repository to your local machine:

   ```bash
   (https://github.com/naveenmarathi/wisecow.git)
   ```

2. Navigate to the cloned repository:

   ```bash
   cd repository
   ```

3. Configure Jenkins pipeline for building and pushing Docker images.
4. Modify Kubernetes deployment files (`deployment.yaml`, `service.yaml`, etc.) with your specific configurations.
5. Apply the Kubernetes deployment:

   ```bash
   kubectl apply -f deployment.yaml
   ```

6. Expose the application via a Kubernetes service:

   ```bash
   kubectl apply -f service.yaml
   ```

7. Access the application using the provided URL or external IP.

## Configuration

### Jenkins Pipeline Configuration

Configure Jenkins to automate the following tasks:

- Build Docker image from source code.
- Push Docker image to a Docker registry (e.g., Docker Hub, AWS ECR).
- Trigger Kubernetes deployment using updated image.

```
Jenkins file

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
```

### Kubernetes Configuration

Update the Kubernetes deployment files (`deployment.yaml`, `service.yaml`, etc.) with the following configurations:

- Container image: Specify the Docker image URL for the WiseCow application.
- Environment variables: Set any required environment variables for the application.
- Resources: Define CPU and memory limits and requests for the application pods.

Conclusion

The WiseCow application has been successfully containerized using Docker and deployed into a Kubernetes cluster managed by Minikube. With the help of Jenkins CI/CD pipelines, the process of building, pushing Docker images, and rolling out Kubernetes deployments has been fully automated.

Key outcomes of this setup:
- Automated CI/CD: Every code push triggers a Jenkins pipeline that builds and publishes a new Docker image and updates the Kubernetes deployment.

- Scalability: Kubernetes manages pods and services, allowing the application to scale easily as demand grows.

- Portability: The containerized application can run not only on Minikube but also on any Kubernetes-based environment such as AWS EKS, GCP GKE, or Azure AKS with minimal changes.

- Reliability: Rollout verification ensures that only healthy pods are deployed, reducing downtime during updates.

- Flexibility: The service is exposed via a NodePort in Minikube, making the application accessible through a browser using the Minikube IP and assigned port.

## Overall, this setup demonstrates an end-to-end DevOps workflow where Git, Jenkins, Docker, and Kubernetes work together to ensure smooth, reliable, and scalable deployments of the WiseCow application.

