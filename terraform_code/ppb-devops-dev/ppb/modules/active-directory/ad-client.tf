
################# AD Client Servers ######################

resource "aws_instance" "ADClient" {
  count = var.enable_ad ? 1 : 0
  ami           = var.windows_ami
  instance_type = "t2.xlarge"
  iam_instance_profile = var.instance_profile
  subnet_id   = element(var.private_subnet_ids, 0) 
  vpc_security_group_ids = var.ad_sg
  key_name          = var.key_name #"terraform-key-${var.app_name}-${var.environment_name}"
  tags = {
    Name = "ppb-ott-${var.env_name}-ADClient"
  }
  user_data = <<EOF
  <powershell>
  #Requires -RunAsAdministrator
  $domainsecretname = "domain_admin_password" #${var.domain_secret_name}
  $ADdomain = "ppbott.local" #${var.ADdomain}
  $primary_domain_controller = "${var.primary_domain_controller}"
  $secondary_domain_controller = "${var.secondary_domain_controller}"
  $NetAdapter=Get-NetAdapter
  $InterfaceIndex=$NetAdapter.InterfaceIndex
  set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("$primary_domain_controller","$secondary_domain_controller")
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-WebRequest -Uri https://awscli.amazonaws.com/AWSCLIV2.msi -UseBasicParsing
  msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi /quiet
  $password1=Get-SECSecretValue -SecretId $domainsecretname -Select SecretString
  $splitsecret=$password1.split(":")
  $password2=$splitsecret[1].trim('}')
  $password3=$password2.trim('"')
  $password = ConvertTo-SecureString -String $password3 -AsPlainText -Force
  $AdminUser = "$ADdomain\Admin"
  $credential = New-Object System.Management.Automation.PSCredential($AdminUser,$password)
  write-host("Domain Joined")
  Add-Computer -DomainName $ADdomain -Credential $credential -Restart -Force
  </powershell>
EOF

  depends_on = [aws_directory_service_directory.ad]
}
