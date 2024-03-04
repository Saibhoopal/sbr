
resource "aws_instance" "aws_bastion" {
  count = 2
  ami           = var.bastion_windows_ami 
  instance_type = var.bastion_instance_type 
  subnet_id     = element(var.bastion_subnet_ids, count.index)  
  vpc_security_group_ids = var.bastion_sg_ids
  iam_instance_profile = var.instance_profile
  key_name          = var.key_name
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-bastion-${count.index+1}"
  })

  user_data = <<EOF
  <powershell>
  #Requires -RunAsAdministrator
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
  Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -UseBasicParsing
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet
  $ADdomain="${var.ADdomain}"
  $ADOU="${var.ADOU}"
  $domainadminuser="${var.domain_admin_user}"
  $domainuser1=Get-SECSecretValue -SecretId $domainadminuser -Select SecretString
  $domainuser2=$domainuser1.split(":")
  $domainuser3=$domainuser2[1].trim('}')
  $AdminUser=$domainuser3.trim('"')
  $domainsecretname="${var.domain_secret_name}"
  $password1=Get-SECSecretValue -SecretId $domainsecretname -Select SecretString
  $splitsecret=$password1.split(":")
  $password2=$splitsecret[1].trim('}')
  $password3=$password2.trim('"')
  $password=ConvertTo-SecureString -String $password3 -AsPlainText -Force
  $credential=New-Object System.Management.Automation.PSCredential($AdminUser,$password)
  write-host("Domain Joined")
  Add-Computer -DomainName $ADdomain -OUPath $ADOU -Credential $credential -Restart -Force
  </powershell>
EOF
}

resource "aws_eip_association" "bastion_eip_association" {
  count = 2
  instance_id   = element(aws_instance.aws_bastion.*.id, count.index)
  allocation_id = element(var.bastion_eip_assoc_ids, count.index) 
}