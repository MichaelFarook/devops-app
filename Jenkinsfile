pipeline {
    agent any
    environment {
        AWS_ACCOUNT="813814720370"
        AWS_REGION="eu-central-1"
        IMAGE_REPO_NAME="devops-app"
        IMAGE_TAG="1.0"
        REPOSITORY_URL = "${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO_NAME}"
        AWS_API_KEY = credentials('aws_credentials')
    }

    stages {

    // Cloning Git Repository 
    stage('Cloning Git') {
      steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'ssh-for-github', url: 'git@github.com:MichaelFarook/devops-app.git']]])
      }
    }

    // Building Docker images
    stage('Building Docker image') {
      agent any
      steps{
        script {
	  sh """ 
	  cd container/
	  ls 
	  docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
	  docker images 
	   """ 
        }
	cleanWs()
      }
    }

    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
      steps{
        script {
	  docker.withRegistry("https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com", "ecr:eu-central-1:aws_credentials") {
	    sh ' docker tag  ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}'
	    sh ' docker push ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO_NAME}:${IMAGE_TAG}' 
          }
        }
      }
    }
  }

  post {
    // Clean after build  
    always { 
      cleanWs(cleanWhenNotBuilt: false, 
        deleteDirs: true, 
      	disableDeferredWipeout: true, 
      	notFailBuild: true,
      	patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
      	           [pattern: '.propsfile', type: 'EXCLUDE']])
    }			   
  }	
}
