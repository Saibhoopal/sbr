####### link to create a lambda function through terraform IaC ####
https://pfertyk.me/2023/02/creating-aws-lambda-functions-with-terraform/


###### lambda layers for the above lambda function to work (Git (w/ ssh) binaries for AWS Lambda) #############
https://pfertyk.me/2023/02/creating-aws-lambda-functions-with-terraform/

###### install terraform through code ###
https://developer.hashicorp.com/terraform/install

### install terraform requrired version ####
########## script to install terraform on jenkins server ##########
#sudo apt-get update
sudo apt-get install -y git
# Clone tfenv repository
sudo git clone https://github.com/tfutils/tfenv.git /usr/local/tfenv
sudo ln -s /usr/local/tfenv/bin/* /usr/local/bin
# Add tfenv to the user's profile
echo 'export PATH="/usr/local/tfenv/bin:$PATH"' | sudo tee -a /etc/profile
# Reload the profile
source /etc/profile
# Install Terraform version 1.3.5
sudo tfenv install 1.3.5
sudo tfenv use 1.3.5

####### script to configuring jenkins server to access the git repo ###########
mkdir -p /var/lib/jenkins/.ssh
ssh-keyscan github.com >> /var/lib/jenkins/.ssh/known_hosts
SECRET_VALUE=$(aws secretsmanager get-secret-value --region $AWS_REGION --secret-id $AWS_SECRET_NAME --query SecretString --output text)
echo "$SECRET_VALUE" > /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh

#### How to clone a private git repo in aws lambda ####
def clone_code(event, context):
    os.system('rm -rf /tmp/*')
    secrets_manager = boto3.client('secretsmanager', region_name=region)
    secret_value = secrets_manager.get_secret_value(SecretId=aws_git_secret)['SecretString']
    id_rsa_path = os.path.join('/tmp', 'id_rsa')
    with open(id_rsa_path, 'w') as id_rsa_file:
        id_rsa_file.write(secret_value)    
    os.chmod('/tmp/id_rsa', 0o600)
    os.system('ssh-keyscan -t rsa github.com | tee /tmp/known_hosts | ssh-keygen -lf -')
    os.environ['GIT_SSH_COMMAND'] = 'ssh -o UserKnownHostsFile=/tmp/known_hosts -i /tmp/id_rsa'
    os.system('git clone git@github.com:theICEway-CloudServices/devops-poc.git /tmp/aws')
    os.system('ls -ltr /tmp/aws')
    os.system('cat /tmp/aws/providers.tf')

######   Setup SSH between Jenkins and Github  ###  
https://levelup.gitconnected.com/setup-ssh-between-jenkins-and-github-e4d7d226b271




