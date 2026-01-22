# Scalable Healthcare Portal

A microservices-based healthcare portal deployed on AWS using ECS Fargate, Terraform, and Docker.

## Folder Hierarchy

### 1. .aws 

Contains a script to create backend s3 buckect for state file

### 2. .github/workflows

Contains deployment workflows to deploy frontend and other services

### 3. modules

Reusable Terraform Modules for ALB, ECS, ECR, VPC, Security groups, Subnets, NAT.

### 4. src 

Contains Application Source Code, Frontend and Backend services with there docker files

### 5. terraform

#### a. infrastructure

contains base Layer (VPC, ALB, ECR, Security Groups)

#### b. services

Contains application Layer (ECS Services, Task Definitions)


## How to Use

### Prerequisites

Ensure you have the following installed and configured:
- **AWS CLI** (Configured with credentials)
- **Terraform** 

### 1. Infrastructure Setup (Terraform)

- The infrastructure is split into two layers Networking, security, ECR, ECS is a first section

- Application resources in a second section. This section is direclty trigger from deployement workflow.

**Step 1: Deploy Base Infrastructure**
This sets up the VPC, Load Balancer, and ECR repositories.
```
cd terraform/infrastructure
terraform init
terraform apply
```

**Step 2: Deploy Application Services**
This deploys the ECS services and connects them to the infrastructure.
```
cd terraform/services
terraform init
terraform apply
```

### 2. Accessing the Application

- Once deployed, the application is accessible via the Application Load Balancer (ALB) URL.

- Frontend page having three buttons of three service with shows the backend data then you click a perticular service button 


`NOTE - I have created dummy backend services for this assessment as the main focus is on the pipelines and infrastructure design.`
