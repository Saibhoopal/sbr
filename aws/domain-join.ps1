
###### for ppb ######
$ADdomain="corp.ppbplc.com"
$ADOU="OU=OTT,OU=Backend Servers,OU=Retail,OU=ENDPOINTS,DC=corp,DC=ppbplc,DC=com" 
$domainsecretname="domain_join_password"
$password1=Get-SECSecretValue -SecretId $domainsecretname -Select SecretString
$splitsecret=$password1.split(":")
$password2=$splitsecret[1].trim('}')
$password3=$password2.trim('"')
$password=ConvertTo-SecureString -String $password3 -AsPlainText -Force
$domainadminuser="domain_join_admin_user"
$domainuser1=Get-SECSecretValue -SecretId $domainadminuser -Select SecretString
$domainuser2=$domainuser1.split(":")
$domainuser3=$domainuser2[1].trim('}')
$AdminUser=$domainuser3.trim('"') 
$credential=New-Object System.Management.Automation.PSCredential($AdminUser,$password)
write-host("Domain Joined")
Add-Computer -DomainName $ADdomain -OUPath $ADOU -Credential $credential -Restart -Force  

for tyrell
$NetAdapter=Get-NetAdapter
$InterfaceIndex=$NetAdapter.InterfaceIndex
set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ($Domain_controllers)
set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ("$primary_domain_controller","$secondary_domain_controller") 

#################
$domainsecretname ="domain_join_password"
$ADdomain ="corp.ppbplc.com"
$ADOU="OU=OTT,OU=Backend Servers,OU=Retail,OU=ENDPOINTS,DC=corp,DC=ppbplc,DC=com"
$password1=Get-SECSecretValue -SecretId $domainsecretname -Select SecretString
$splitsecret=$password1.split(":")
$password2=$splitsecret[1].trim('}')
$password3=$password2.trim('"')
$password = ConvertTo-SecureString -String $password3 -AsPlainText -Force
$AdminUser = "CORP\svc_ottdomainjoin"
$credential = New-Object System.Management.Automation.PSCredential($AdminUser,$password)
write-host("Domain Joined")
Add-Computer -DomainName $ADdomain -OUPath $ADOU -Credential $credential -Restart -Force  


