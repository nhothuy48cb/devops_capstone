[![CircleCI](https://circleci.com/gh/nhothuy48cb/devops_capstone.svg?style=svg)](https://app.circleci.com/pipelines/github/nhothuy48cb/devops_capstone)
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
2. [Setup kubernetes cluster](#setup-kubernetes-cluster)
3. [Setup CircleCI](#setup-circleci)
4. [CI/CD Pipeline](#cicd-pipeline)

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
  2. Use [infa/cluster.yaml](./infa/cluster.yaml) to create Amazon EKS cluster (take ~ 15-20 mins)
      ```
     $ eksctl create cluster -f infa/cluster.yaml
     ```
     - Stacks:
     ![cf_stack_eksctl_production_cluster.png](./screenshots/cf_stack_eksctl_production_cluster.png)
     - Cluster:
     ![eks_clusters_production.png](./screenshots/eks_clusters_production.png)
  3. Configure `kubectl` for Amazon EKS:
      ```
     $ aws eks --region us-west-2 update-kubeconfig --name production
     $ kubectl config current-context
      ```
  4. Check nodes
      ```
     $ kubectl get nodes
      ```
     ![kubectl_get_nodes.png](./screenshots/kubectl_get_nodes.png)
- Publish version 1.0:
  1. Build and push docker image version 1.0
     ```
     $ make build-docker
     $ make upload-docker
     ```
  2. Publish the version 1.0 user docker image [nhothuy48cb/flask-app:1.0](https://hub.docker.com/layers/254101442/nhothuy48cb/flask-app/1.0/images/sha256-d9c17a79c90e4f386965bec9594121b99005c60b523b76629c043e88538edfa6?context=repo) (create a deployment `flask-app-1-0` using the [k8s/1.0/deployment.yaml](./k8s/1.0/deployment.yaml) file and create a service `flask-app` using the [k8s/1.0/service.yaml](./k8s/1.0/service.yaml) file)
     ```
     $ kubectl apply -f k8s/1.0/deployment.yaml
     $ kubectl apply -f k8s/1.0/service.yaml
     ```
     That is blue version 1.0
  3. Check result
     ```
     $ kubectl get all
     ```
     ![kubectl_get_all_1.0.png](./screenshots/kubectl_get_all_1.0.png)
     Go to ELB's URL to check flask-app version 1.0
     ![flask_app_blue_1.0.png](./screenshots/flask_app_blue_1.0.png)
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
Overview:
![circleci_pipeline.png](./screenshots/circleci_pipeline.png)
Steps:
1. run-lint: use `hadolint` and `pylint`
  ![run_lint.png](./screenshots/run_lint.png)
  ![run_lint_failed.png](./screenshots/run_lint_failed.png)
2. build-and-push-docker-image: build and push docker image to https://hub.docker.com/
  ![build_publish_docker_image.png](./screenshots/build_publish_docker_image.png)
  ![flask_app_docker_image.png](./screenshots/flask_app_docker_image.png)
- Link to [flask-app Image](https://hub.docker.com/repository/docker/nhothuy48cb/flask-app/general)
3. deploy-green: publish the new version as green
- Using the blue/green deployment pattern, follow the [link](https://jeromedecoster.github.io/aws/kubernetes-eks-blue/green-deployment/).
- Use [k8s/deployment.yaml](./k8s/deployment.yaml) file to create new deployment `flask-app-$LABEL_VERSION` (eg: flask-app-2-0, flask-app-2-1, ..).
- Use [k8s/service-green.yaml](./k8s/service-green.yaml) file to create a new service (a new Load Balancer) `flask-app-green`, the service only for testing purposes.
  ![kubectl_get_all_green.png](./screenshots/kubectl_get_all_green.png)
- Green deployment:
  ![flask_app_green_2.0.png](./screenshots/flask_app_green_2.0.png)
- Blue deployment:
  ![flask_app_blue_1.0.png](./screenshots/flask_app_blue_1.0.png)
6. wait-manual-approval: wait manual approval to target the new version - new blue after verifying that our new version (green deployment) is working correctly.
   ![approve_job.png](./screenshots/approve_job.png)
7. deploy-new-blue: target the new version - new blue
- Blue deployment:
  ![flask_app_blue_2.0.png](./screenshots/flask_app_blue_2.0.png)
8. remove-old-blue: free up the resources (with previous version)
   ![kubectl_get_all_2.0.png](./screenshots/kubectl_get_all_2.0.png)