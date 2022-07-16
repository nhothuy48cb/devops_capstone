## Project Overview

Capstone project for Udacity's "Cloud DevOps Engineer" Nanodegree Program.

<hr>

## Objectives

- Working in AWS
- Using CircleCI to implement Continuous Integration and Continuous Deployment
- Building pipelines
- Building Kubernetes clusters
- Building Docker containers in pipelines

<hr>

## Tools Used

- Git & GitHub
- AWS & aws-cli
- Python3, Flask framework, pip3
- Docker & Docker-Hub registery
- CircleCI
- Kubernetes cli (kubectl)
- EKS

<hr>

## Project Steps

1. [Development](#development)
2. [Setup kubernetes cluster](#Setup kubernetes cluster)
3. [Setup CircleCI](#Setup CircleCI)
4. [CI/CD Pipeline](#CI/CD Pipeline)

<hr>


### Development

- Simple flask application.

<hr>

- **Develop (Local manual check):**

  ```
  $ make setup
  $ make install
  $ make test
  $ make lint
  $ make run-app
  ```
- **Docker Containerization (Local manual check):**
  ```
  $ make build-docker
  $ make run-docker
  $ make upload-docker
  ```
<hr>

### Setup kubernetes cluster
- Install aws cli
- Install eksctl
- Install kubectl
- Create Amazon EKS cluster:
  1. Create key pair: `key-pair-us-west-2` use to connect to nodes in cluster.
  2. Use [infa/cluster.yaml](./infa/cluster.yaml) to create Amazon EKS cluster (name: `production`, region: `us-west-2`)
      ```
     $ eksctl create cluster -f infa/cluster.yaml
     ```
  3. Configure `kubectl` for Amazon EKS:
      ```
     $ aws eks --region us-west-2 update-kubeconfig --name production
     $ kubectl config current-context
      ```
  4. Check nodes
      ```
     $ kubectl get nodes
      ```
- Publish version 1.0:
  1. Build and push docker image
  2. Publish the version 1.0
      ```
     $ kubectl apply -f k8s/1.0/deployment.yaml
     $ kubectl apply -f k8s/1.0/service.yaml
      ```
  3. Check result
     ```
     $ kubectl get all
     ```
<hr>

### Setup CircleCI
Add the following environment variables to your Circle CI project by navigating to {project name} > Settings > Environment Variables as shown [here](https://circleci.com/docs/settings):
- `AWS_ACCESS_KEY_ID`=(from IAM user with programmatic access)
- `AWS_SECRET_ACCESS_KEY`=(from IAM user with programmatic access)
- `AWS_DEFAULT_REGION`=(your default region in aws)
- `CLUSTER_NAME`=(your eks cluster name, eg: production)
- `DOCKER_LOGIN`=(your username to login https://hub.docker.com/)
- `DOCKER_PASSWORD`=(your password to login https://hub.docker.com/)
- `DOCKER_HUB_ID`=(your docker id in https://hub.docker.com/, eg: nhothuy48cb)
- `DOCKER_REPOSITORY`={your repository in https://hub.docker.com/, eg: flask-app}
<hr>

### CI/CD Pipeline
