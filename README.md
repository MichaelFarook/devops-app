** My devops-project **  

This project contain static website and Dockerfile in folder 'container'.
An image built form this Dockerfile was uploaded to my private Amazon ECR(Elastic Container Registry).

Inside devops-project/helm/ there's the default helm chart/values files and a folder titled 'templates'. Inside it are the 5 kubernetes yaml files used for deploying the application: Deployment, Service-NodePort, Ingress, HPA(Horizontal Pod Autoscaler), and CronJob.

The CronJob was created to solve the problem with AWS token that in avalable fo 12 hours, CronJob is sheduled to run every 10 hours which deletes old key and prepares a new one with the same name. 

The Jenkinsfile have few stages in pipeline: 
- Cloning Gis Repository
- Building Docker image
- Uploading Docker image into AWS ECR
- Cleaning after build

The main goal of Jenkinsfile pipeline is take the Dockerfile from the GitHub repository, build it and upload to AWS. 
