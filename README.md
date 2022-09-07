## Demo ECS service on Fargate

This is a demo of running AWS ECS two tier service on Fargate.

This demo includes definition of tree containers (under dockerfiles directory):
* **db_init** - container required for initial database setup, 
including database creation and user configration 
to enable AIM authentication, using a simple bash script.
After the init process, the contener is set for indefinete floop. 
* **web_app_php** - simple PHP page, which connects to the database and executes a
simple qiery "SHOW DATABASES"
* **web_app_django** - a demo Pytho web service using Jango framework, which connects 
to the database and executes a simple query "SHOW DATABASES"

The containers can be build using the **deploy.sh** script.

Both web_app containers demostrates the use of **IAM authentication** without 
the need to store any credentials for accescing the database.

All the containers are running in **Fargate**.

The VPC used for the demo is set with **public** and **private** sunets.

Containers for the web_app are using **public subnets**, as they will be publicaly accessed.

Container for the database initialization and the database, are using the **private subnets**.

The root password for the database is stored in **Secret Manager**, and it is used only
by **init_db** container create web_app used and enable IAM password authentication.

### Container images build
Building of container images can be done manually, by using deploy.sh script under dockerfiles directory, or via GitHub actions using sample workflow under .github/workflows_samples 

### Environemnt deployment
The deployment of the environment is done via Terraform. Before deployment of the 
environment, ECR and container images must be created and build (via deploy.sh script or workflow)

From **variables.tf** file, settings for the VPC, subnets, database user and ECS images can be managed.

All containers logs are sent to CloudWatch Logs.

Running terraform can be done via GitHub actions using sample workflow under .github/workflows_samples

## Using GitHub workflows
Both sample GitHub worflows will require **OIDC setup** on AWS account and a role with all required privileges.
The AWS **role arn** needs to be stored as GitHub secrets with name **AWS_ROLE**

**Note: GitHub sample workflows are not tested and may need some tweaks.** 
