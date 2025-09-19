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
}```

### Kubernetes Configuration

Update the Kubernetes deployment files (`deployment.yaml`, `service.yaml`, etc.) with the following configurations:

- Container image: Specify the Docker image URL for the WiseCow application.
- Environment variables: Set any required environment variables for the application.
- Resources: Define CPU and memory limits and requests for the application pods.

# Cow wisdom web server

## Prerequisites

```
sudo apt install fortune-mod cowsay -y
```

## How to use?

1. Run `./wisecow.sh`
2. Point the browser to server port (default 4499)

## What to expect?
![wisecow](https://github.com/nyrahul/wisecow/assets/9133227/8d6bfde3-4a5a-480e-8d55-3fef60300d98)

# Problem Statement
Deploy the wisecow application as a k8s app

## Requirement
1. Create Dockerfile for the image and corresponding k8s manifest to deploy in k8s env. The wisecow service should be exposed as k8s service.
2. Github action for creating new image when changes are made to this repo
3. [Challenge goal]: Enable secure TLS communication for the wisecow app.

## Expected Artifacts
1. Github repo containing the app with corresponding dockerfile, k8s manifest, any other artifacts needed.
2. Github repo with corresponding github action.
3. Github repo should be kept private and the access should be enabled for following github IDs: nyrahul
