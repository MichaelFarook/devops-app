#!/usr/bin/env bash
#
# This is script of cronjob to Updating-AWS ECR Tocken 
# It will automatically keep refresh tockens 
#


# Creating a log file that cron job will output to 
sudo touch /var/log/aws-ecr-update-credentials.log

# Make a current user owner of the file so that cronjob running under his/its account can write to it 
sudo chown $USER /var/log/aws-ecr-update-credentials.log

# Create an empty file where the script would reside 
sudo touch /usr/local/bin/aws-ecr-update-credentials.sh

# Allow cronjob to execute the script under the user 
sudo chown $USER /usr/local/bin/aws-ecr-update-credentials.sh \

# Make the script executable 
sudo chmod +x /usr/locla/bin/aws-ecr-update-credentials.sh 


kube_namespaces=($(kubectl get secret --all-namespaces | grep regcred | awk '{print $1}'))
for i in "${kube_namespaces[@]}"
do
  :
  echo "$(date): Updating secret for namespace - $i"
  kubectl delete secret regcred --namespace $i
  kubectl create secret docker-registry regcred \
  --docker-server=${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com \
  --docker-username=AWS \
  --docker-password=$(/usr/local/bin/aws ecr get-login-password) \
  --namespace=$i
done

# Open crontab file 
crontab -e 

# Job 
0 */10 * * * /usr/local/bin/aws-ecr-update-credential.sh >> /var/log/aws-ecr-update-credentials.log 2>&1 

