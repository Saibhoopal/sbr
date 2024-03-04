#!/bin/bash
#######aws config ##############
AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')
AWS_ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)
AWS_SECRET_NAME="github-ssh-key"
jenkins_user="iceway"
jenkins_password="Iceway_123"
sudo apt update
sudo apt-get install python3-pip -y
sudo apt install unzip
mkdir /tmp/ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb
sudo dpkg -i amazon-ssm-agent.deb
sudo systemctl status amazon-ssm-agent

##### install jenkins ########
sudo apt-get update -y
# Install Java SDK 17
sudo apt-get install fontconfig openjdk-17-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install jenkins -y
# Start Jenkins
sudo systemctl start jenkins
# Enable Jenkins to run on Boot
sudo systemctl enable jenkins

############# configure jenkins ##########
url=http://localhost:8080
password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
username=$(python3 -c "import urllib.parse; print(urllib.parse.quote(input(), safe=''))" <<< $jenkins_user)
new_password=$(python3 -c "import urllib.parse; print(urllib.parse.quote(input(), safe=''))" <<< $jenkins_password)
# GET THE CRUMB AND COOKIE
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "admin:$password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO CREATE AN ADMIN USER
curl -X POST -u "admin:$password" $url/setupWizard/createAdminUser \
        -H "Connection: keep-alive" \
        -H "Accept: application/json, text/javascript" \
        -H "X-Requested-With: XMLHttpRequest" \
        -H "$full_crumb" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --cookie $cookie_jar \
        --data-raw "username=$username&password1=$new_password&password2=$new_password&Jenkins-Crumb=$only_crumb&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D&core%3Aapply=&Submit=Save&json=%7B%22username%22%3A%20%22$username%22%2C%20%22password1%22%3A%20%22$new_password%22%2C%20%22%24redact%22%3A%20%5B%22password1%22%2C%20%22password2%22%5D%2C%20%22password2%22%3A%20%22$new_password%22%2C%20%22Jenkins-Crumb%22%3A%20%22$only_crumb%22%7D"

########## install plugins #########
url=http://localhost:8080
cookie_jar="$(mktemp)"
full_crumb=$(curl -u "$jenkins_user:$jenkins_password" --cookie-jar "$cookie_jar" $url/crumbIssuer/api/xml?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
arr_crumb=(${full_crumb//:/ })
only_crumb=$(echo ${arr_crumb[1]})

# MAKE THE REQUEST TO DOWNLOAD AND INSTALL REQUIRED MODULES
curl -X POST -u "$user:$password" $url/pluginManager/installPlugins \
  -H 'Connection: keep-alive' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H "$full_crumb" \
  -H 'Content-Type: application/json' \
  -H 'Accept-Language: en,en-US;q=0.9,it;q=0.8' \
  --cookie $cookie_jar \
  --data-raw "{'dynamicLoad':true,'plugins':['git','ec2','aws-lambda','job-dsl','github-branch-source','pipeline-github','ws-cleanup','ant','gradle','build-timeout','github-branch-source','pipeline-github-lib','pipeline-stage-view','ssh-slaves','matrix-auth','pam-auth','ldap','email-ext','mailer'],'Jenkins-Crumb':'$only_crumb'}"

sleep 60
####### install Jenkins cli and seed_job creation #######
wget http://localhost:8080/jnlpJars/jenkins-cli.jar -O /var/lib/jenkins/jenkins-cli.jar
cat > /var/lib/jenkins/jobs/seed_job.xml << 'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<project>
  <!-- Your existing XML content here -->

  <builders>
    <javaposse.jobdsl.plugin.ExecuteDslScripts plugin="job-dsl@1.87">
      <scriptText><![CDATA[
// Define parameters for the DSL jobs
def awsRegion = '$aws_region'
def awsAccount = '$aws_account'

// DSL1
// invoke_terraform dsl job
def git_repo_url = ''
def client_bucket_name = ''

// Create the Jenkins job using DSL
job('invoke_terraform') {
    description('Job to run Terraform commands')
    parameters {
        stringParam('GIT_REPO_URL', git_repo_url, 'The Git repository URL containing the Terraform code to build the infrastructure in AWS')
        stringParam('CLIENT_BUCKET_NAME', client_bucket_name, 'The client-side S3 bucket name used to save the Terraform state file')
    }

    steps {
        shell('ssh-agent bash -c "ssh-add /var/lib/jenkins/.ssh/id_rsa; git clone $GIT_REPO_URL"')
        shell('sed -i "s/CLIENT-BUCKET-NAME/$CLIENT_BUCKET_NAME/g" ./devops-poc/providers.tf')
        shell('terraform -chdir=./devops-poc init')
        shell('terraform -chdir=./devops-poc plan')
        shell('terraform -chdir=./devops-poc apply -auto-approve')
    }
}

//DSL2
// Define parameters for the rolling_server_resatrt DSL job
def rolling_server_restart_sfn_arn = 'arn:aws:states:' + awsRegion + ':' + awsAccount + ':stateMachine:rolling-server-restart'
def rolling_server_restart_inputJson = '{"service_restart": "jease", "target_group_arn":""}'

// Create the Jenkins job using DSL
job('rolling_server_restart_Job') {
    parameters {
        stringParam('AWS_REGION', awsRegion, 'AWS Region')
        stringParam('STEP_FUNCTION_ARN', rolling_server_restart_sfn_arn, 'arn of rolling server restart step function')
        stringParam('INPUT_JSON', rolling_server_restart_inputJson, 'input for the rolling server restart step function')
    }
    steps {
        shell('''#!/bin/bash

# Stage: Invoke Step Function
echo "Starting 'Invoke Step Function' stage..."
executionArn=$(aws stepfunctions start-execution --region $AWS_REGION --state-machine-arn $STEP_FUNCTION_ARN --input "$INPUT_JSON" --output text --query executionArn)
echo "Step Function execution started with ARN: $executionArn"

# Check the status of the execution periodically
status=''
while [[ $status != 'SUCCEEDED' && $status != 'FAILED' ]]; do
    sleep 20
    status=$(aws stepfunctions describe-execution --region $AWS_REGION --execution-arn $executionArn --query 'status' --output text)
    echo "$(date) Step Function execution status: $status"
done

echo "Step Function execution completed with status: $status"''')
    }
}

//DSL3
// Define parameters for the configure_app_server_job DSL job
def config_app_server_sfn_arn = 'arn:aws:states:' + awsRegion + ':' + awsAccount + ':stateMachine:iceway-app-config'
def config_app_server_inputJson = '{"server_type": "jease", "version": "default", "tags": {"Name": "server_name", "env": "dev", "app": "jease" }}'
// Create the Jenkins job using DSL
job('configure_app_server_job') {
    parameters {
        stringParam('AWS_REGION', awsRegion, 'AWS Region')
        stringParam('STEP_FUNCTION_ARN', config_app_server_sfn_arn, 'arn of config app server step function')
        stringParam('INPUT_JSON', config_app_server_inputJson, 'input for the config app server step function')
    }
    steps {
        shell('''#!/bin/bash

# Stage: Invoke Step Function
echo "Starting 'Invoke Step Function' stage..."
executionArn=$(aws stepfunctions start-execution --region $AWS_REGION --state-machine-arn $STEP_FUNCTION_ARN --input "$INPUT_JSON" --output text --query executionArn)
echo "Step Function execution started with ARN: $executionArn"

# Check the status of the execution periodically
status=''
while [[ $status != 'SUCCEEDED' && $status != 'FAILED' ]]; do
    sleep 20
    status=$(aws stepfunctions describe-execution --region $AWS_REGION --execution-arn $executionArn --query 'status' --output text)
    echo "$(date) Step Function execution status: $status"
done

echo "Step Function execution completed with status: $status"''')
    }
}
      ]]></scriptText>
      <usingScriptText>true</usingScriptText>
      <sandbox>false</sandbox>
      <ignoreExisting>false</ignoreExisting>
      <ignoreMissingFiles>false</ignoreMissingFiles>
      <failOnMissingPlugin>false</failOnMissingPlugin>
      <failOnSeedCollision>false</failOnSeedCollision>
      <unstableOnDeprecation>false</unstableOnDeprecation>
      <removedJobAction>IGNORE</removedJobAction>
      <removedViewAction>IGNORE</removedViewAction>
      <removedConfigFilesAction>IGNORE</removedConfigFilesAction>
      <lookupStrategy>JENKINS_ROOT</lookupStrategy>
    </javaposse.jobdsl.plugin.ExecuteDslScripts>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
EOF
# Replace placeholders with actual values
sed -i "s/\$aws_region/$AWS_REGION/g" /var/lib/jenkins/jobs/seed_job.xml
sed -i "s/\$aws_account/$AWS_ACCOUNT/g" /var/lib/jenkins/jobs/seed_job.xml
java_path=$(which java)
$java_path -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ -auth $jenkins_user:$jenkins_password create-job seed_job < /var/lib/jenkins/jobs/seed_job.xml
echo "jenkins job created, status_code $?"
sleep 30

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



######################## jenkins Script approval  ########
#!/bin/bash
echo ""

#default location of the Jenkins approval file
APPROVE_FILE="/var/lib/jenkins/scriptApproval.xml"

#creating an array of the signatures that need approved
SIGS=(
'method hudson.model.ItemGroup getItem java.lang.String'
'staticMethod jenkins.model.Jenkins getInstance'
)

#stepping through the array
for i in "${SIGS[@]}"; do
   echo "Adding :"
   echo "$i"
   echo "to $APPROVE_FILE"
   echo ""
   #checking the xml file to see if it has already been added, then deleting. this is a trick to keep xmlstarlet from creatine duplicates
   xmlstarlet -q ed --inplace -d "/scriptApproval/approvedSignatures/string[text()=\"$i\"]" $APPROVE_FILE

   #adding the entry
   xmlstarlet -q ed --inplace -s /scriptApproval/approvedSignatures -t elem -n string -v "$i" $APPROVE_FILE
   echo ""
done

echo "##### Completed updating "$APPROVE_FILE", displaying file: #####"
#cat "$APPROVE_FILE"

cat > /var/lib/jenkins/javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration.xml << 'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration plugin="job-dsl@1.87">
  <useScriptSecurity>false</useScriptSecurity>
</javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration>
EOF

systemctl restart jenkins.service
