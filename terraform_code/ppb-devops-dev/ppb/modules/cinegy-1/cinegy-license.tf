
resource "aws_instance" "cinegy_license_server" {
  count = 1 
  ami           = var.windows_ami
  instance_type = var.cinegy_license_instance_type  
  subnet_id   = element(var.cinegy_private_subnet_ids, count.index)
  vpc_security_group_ids = var.cinegy_sg_ids
  key_name          = var.key_name
  iam_instance_profile = var.instance_profile
  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.environment}-${var.service}-license-${count.index+1}"
  })

  user_data = base64encode(
  <<EOF
  <powershell>
  #Requires -RunAsAdministrator
  New-Item -ItemType Directory -Force -Path C:\UserData
  $domainsecretname="${var.domain_secret_name}"
  $domainadminuser="${var.domain_admin_user}"
  $ADdomain="${var.ADdomain}"
  $ADOU="${var.ADOU}"
  $R53Domain="${var.R53Domain}"
  $Recordsetsubdomainprefix="${var.license_Recordset_subdomain_prefix}"
  $bucket="${var.bucket_name}"  
  $files=Get-S3Object -BucketName $bucket -Key license.ps1
  foreach($file in $files) {
    Copy-S3Object -SourceBucket $bucket -SourceKey $($file.Key) -LocalFolder 'C:\UserData'
  }
  C:\UserData\license.ps1
  </powershell>
  EOF
  )
}
