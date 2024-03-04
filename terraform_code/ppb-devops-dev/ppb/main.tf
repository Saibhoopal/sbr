
module "security-groups" {
  source = ".//modules/security-groups"
  project = local.workspace["project"]
  environment = local.workspace["env_name"] 
  vpc_id = local.workspace["vpc_id_${data.aws_region.current.name}"]
  vpc_cidr_range = local.workspace["vpc_cidr_range_${data.aws_region.current.name}"]
  public_subnet_cidr_range = local.workspace["public_subnet_cidr_range_${data.aws_region.current.name}"]
  ppb_internet_access_pl = local.workspace["ppb_internet_access_pl_${data.aws_region.current.name}"]
  ppb_network_pl = local.workspace["ppb_network_pl_${data.aws_region.current.name}"]
  retailott_red5pro_pl = var.retailott_red5pro_pl
  retailott_support_pl = var.retailott_support_pl
  retail_shops_pl = var.retail_shops_pl
  ppb_cloudflare_pl = local.workspace["ppb_cloudflare_pl_${data.aws_region.current.name}"] 
  shared_account_cidr_range = local.workspace["shared_account_cidr_range_${data.aws_region.current.name}"]
  common_tags = local.common_tags
  monitoring_subnet_range = local.workspace["monitoring_subnet_range"]
}

################ Active Directory Module (Not  required for PPB) ####################
#module "ad" {
#  source = ".//modules/active-directory"
#  count = 0 
##  count = local.workspace["create_active_directory_for_${data.aws_region.current.name}"] ? 1 : 0
#
#  domain_name = local.workspace["domain_name"]
#  domain_admin_password = var.domain_admin_password
#  domain_secret_name = local.workspace["domain_secret_name"]
#  private_subnet_ids = local.workspace["${data.aws_region.current.name}_private_subnet_ids"]
#  vpc_id = local.workspace["${data.aws_region.current.name}_vpc_id"]
#  enable_ad = local.workspace["enable_ad_for_${data.aws_region.current.name}"]
#  directory_type = local.workspace["directory_type"]
#  directory_edition = local.workspace["directory_edition"]
#  windows_ami = local.workspace["${data.aws_region.current.name}_windows_ami"]
#  ad_sg = [module.security-groups.adclient-sg, module.security-groups.internetaccess-sg]
#  key_name = local.workspace["key_name"]
#  env_name = local.workspace["env_name"]
#  instance_profile = module.iam.ec2_instance_profile_name 
#  primary_domain_controller = local.workspace["${data.aws_region.current.name}_primary_domain_controller"]
#  secondary_domain_controller = local.workspace["${data.aws_region.current.name}_secondary_domain_controller"]
#  ADdomain = local.workspace["ADdomain"] 
#}

module "bastion" {
  source = ".//modules/bastion"
  count = local.workspace["create_bastion_for_${data.aws_region.current.name}"] ? 1 : 0
  environment = local.workspace["env_name"]
  project = local.workspace["project"]
  common_tags = local.common_tags
  key_name    = local.workspace["key_name_for_${data.aws_region.current.name}"]
  bastion_windows_ami = local.workspace["bastion_windows_ami_for_${data.aws_region.current.name}"]
  bastion_instance_type = local.workspace["bastion_instance_type_${data.aws_region.current.name}"]
  bastion_subnet_ids   = local.workspace["public_subnet_ids_for_${data.aws_region.current.name}"]
  bastion_sg_ids  = [module.security-groups.bastion-sg, module.security-groups.internetaccess-sg]
  instance_profile = local.workspace["instance_profile"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user  = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  bastion_eip_assoc_ids = local.workspace["bastion_eip_assoc_ids_for_${data.aws_region.current.name}"]
}  

module "cinegy_ae1_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae1_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae1-main"
  AirengineName = "cinegy-ae1-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE1Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE1Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE1Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE1Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"] 
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae1_main"]
}

module "cinegy_ae1_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae1_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae1-backup"
  AirengineName = "cinegy-ae1-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE1Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE1Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE1Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE1Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae1_backup"]
}

module "cinegy_ae2_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae2_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae2-main"
  AirengineName = "cinegy-ae2-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"] 
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE2Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE2Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE2Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE2Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae2_main"]
}

module "cinegy_ae2_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae2_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae2-backup"
  AirengineName = "cinegy-ae2-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"] 
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE2Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE2Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE2Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE2Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae2_backup"]
}

module "cinegy_ae3_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae3_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae3-main"
  AirengineName = "cinegy-ae3-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE3Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE3Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE3Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE3Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae3_main"]
}

module "cinegy_ae3_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae3_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae3-backup"
  AirengineName = "cinegy-ae3-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE3Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE3Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE3Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE3Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae3_backup"]
}

module "cinegy_ae4_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae4_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae4-main"
  AirengineName = "cinegy-ae4-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE4Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE4Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE4Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE4Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae4_main"]
}

module "cinegy_ae4_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae4_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae4-backup"
  AirengineName = "cinegy-ae4-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE4Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE4Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE4Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE4Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae4_backup"]
}

module "cinegy_ae5_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae5_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae5-main"
  AirengineName = "cinegy-ae5-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE5Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE5Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE5Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE5Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae5_main"]
}

module "cinegy_ae5_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae5_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae5-backup"
  AirengineName = "cinegy-ae5-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE5Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE5Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE5Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE5Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae5_backup"]
}

module "cinegy_ae6_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae6_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae6-main"
  AirengineName = "cinegy-ae6-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE6Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE6Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE6Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE6Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae6_main"]
}

module "cinegy_ae6_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae6_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae6-backup"
  AirengineName = "cinegy-ae6-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE6Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE6Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE6Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE6Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae6_backup"]
}

module "cinegy_ae7_main" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae7_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae7-main"
  AirengineName = "cinegy-ae7-main"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE7Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE7Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE7Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE7Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae7_main"]
}

module "cinegy_ae7_backup" {
  source = ".//modules/cinegy_ae"
  count = local.workspace["create_cinegy_ae7_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_ae_name = "ae7-backup"
  AirengineName = "cinegy-ae7-backup"
  Cinegy_Air_Version = var.Cinegy_Air_Version
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_air_instance_type = local.workspace["cinegy_air_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_AEMain_Config_0_S3path = local.workspace["Cinegy_AE7Main_Config_0_S3path"]
  Cinegy_AEMain_Config_1_S3path = local.workspace["Cinegy_AE7Main_Config_1_S3path"]
  Cinegy_AEBackup_Config_0_S3path = local.workspace["Cinegy_AE7Backup_Config_0_S3path"]
  Cinegy_AEBackup_Config_1_S3path = local.workspace["Cinegy_AE7Backup_Config_1_S3path"]
  Cinegy_AudioMatrix_Config_S3path = local.workspace["Cinegy_AudioMatrix_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  air_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_ae7_backup"]
}

module "cinegy_mvwr_main" {
  source = ".//modules/cinegy_mvwr"
  count = local.workspace["create_cinegy_mvwr_main_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_mvwr_name = "mvwr-main"
  AirengineName = "cinegy-multiviewer-main"
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_multiviewer_instance_type  = local.workspace["cinegy_multiviewer_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1a"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_Mainmvwr_Layout_S3path = local.workspace["Cinegy_Mainmvwr_Layout_S3path"]
  Cinegy_Mainmvwr_Config_S3path = local.workspace["Cinegy_Mainmvwr_Config_S3path"]
  Cinegy_Backupmvwr_Layout_S3path = local.workspace["Cinegy_Backupmvwr_Layout_S3path"]
  Cinegy_Backupmvwr_Config_S3path = local.workspace["Cinegy_Backupmvwr_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  multiviewer_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_multiviewer_main"]
}

module "cinegy_mvwr_backup" {
  source = ".//modules/cinegy_mvwr"
  count = local.workspace["create_cinegy_mvwr_backup_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  cinegy_mvwr_name = "mvwr-backup"
  AirengineName = "cinegy-multiviewer-backup"
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_multiviewer_instance_type  = local.workspace["cinegy_multiviewer_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_eu-west-1b"]
  windows_ami_name = var.windows_ami_name
  instance_profile = local.workspace["instance_profile"]
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  Cinegy_Mainmvwr_Layout_S3path = local.workspace["Cinegy_Mainmvwr_Layout_S3path"]
  Cinegy_Mainmvwr_Config_S3path = local.workspace["Cinegy_Mainmvwr_Config_S3path"]
  Cinegy_Backupmvwr_Layout_S3path = local.workspace["Cinegy_Backupmvwr_Layout_S3path"]
  Cinegy_Backupmvwr_Config_S3path = local.workspace["Cinegy_Backupmvwr_Config_S3path"]
  cinegy_license_address = local.workspace["cinegy_license_address"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  multiviewer_Recordset_subdomain_prefix = local.workspace["recordset_for_cinegy_multiviewer_backup"]
}

############ this module contain cinegy license server ###################
module "cinegy-1" {
  source = ".//modules/cinegy-1"
  count = local.workspace["create_cinegy_license_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "cinegy"
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  cinegy_license_instance_type = local.workspace["cinegy_license_instance_type"]
  cinegy_sg_ids = [module.security-groups.cinegy-sg, module.security-groups.internetaccess-sg]
  cinegy_private_subnet_ids = local.workspace["private_subnet_ids_for_${data.aws_region.current.name}"]
  windows_ami= local.workspace["windows_ami_for_${data.aws_region.current.name}"]
  instance_profile = local.workspace["instance_profile"] 
  bucket_name = local.workspace["s3_bucket_name_for_cinegy"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
  R53Domain = local.workspace["R53Domain"]
  license_Recordset_subdomain_prefix = local.workspace["${data.aws_region.current.name}_license_Recordset_subdomain_prefix"]
}

module "iam" {
  count = local.workspace["create_iam_for_${data.aws_region.current.name}"] ? 1 : 0
  source = ".//modules/iam"
  environment = local.workspace["env_name"]
  project = local.workspace["project"]
  common_tags = local.common_tags
}

module "red5pro" {
  count = local.workspace["create_red5pro_for_${data.aws_region.current.name}"] ? 1 : 0
  source = ".//modules/red5pro"   
  access_key_aws = var.access_key_aws
  secret_key_aws = var.secret_key_aws
  aws_region = data.aws_region.current.name 
  project = local.workspace["project"]
  service= "red5pro"
  environment = local.workspace["env_name"]
  common_tags = local.common_tags
  tag_organisation = local.workspace["tag_organisation"]
  tag_business_vertical = local.workspace["tag_business_vertical"]
  tag_tla = local.workspace["tag_tla"]
  tag_cost_code = local.workspace["tag_cost_code"]
  tag_createdby = local.workspace["tag_createdby"]
  tag_aws_inspector = local.workspace["tag_aws_inspector"]
  tag_service = local.workspace["tag_service"]
  vpc_id = local.workspace["vpc_id_${data.aws_region.current.name}"]
  instance_profile = local.workspace["instance_profile"]  

  red5pro_sm_eip_allocation_id_a = local.workspace["red5pro_sm_eip_allocation_id_a_${data.aws_region.current.name}"]
  red5pro_sm_eip_allocation_id_b = local.workspace["red5pro_sm_eip_allocation_id_b_${data.aws_region.current.name}"]
  red5pro_nm_eip_allocation_id_a = local.workspace["red5pro_nm_eip_allocation_id_a_${data.aws_region.current.name}"]
  red5pro_nm_eip_allocation_id_b = local.workspace["red5pro_nm_eip_allocation_id_b_${data.aws_region.current.name}"]
  red5pro_ts_eip_allocation_id_a = local.workspace["red5pro_ts_eip_allocation_id_a_${data.aws_region.current.name}"]
  red5pro_ts_eip_allocation_id_b = local.workspace["red5pro_ts_eip_allocation_id_b_${data.aws_region.current.name}"]
  sm_nlb_eip_allocation_id_a = local.workspace["sm_nlb_eip_allocation_id_a_${data.aws_region.current.name}"]
  sm_nlb_eip_allocation_id_b = local.workspace["sm_nlb_eip_allocation_id_b_${data.aws_region.current.name}"]
  nm_nlb_eip_allocation_id_a = local.workspace["nm_nlb_eip_allocation_id_a_${data.aws_region.current.name}"]
  nm_nlb_eip_allocation_id_b = local.workspace["nm_nlb_eip_allocation_id_b_${data.aws_region.current.name}"]
  ts_nlb_eip_allocation_id_a = local.workspace["ts_nlb_eip_allocation_id_a_${data.aws_region.current.name}"]
  ts_nlb_eip_allocation_id_b = local.workspace["ts_nlb_eip_allocation_id_b_${data.aws_region.current.name}"]
  public_subnet_a = local.workspace["public_subnet_a_for_nlb_${data.aws_region.current.name}"]
  public_subnet_b = local.workspace["public_subnet_b_for_nlb_${data.aws_region.current.name}"]

  public_subnets = local.workspace["public_subnet_ids_for_${data.aws_region.current.name}"]
  red5pro_mysql_sg_id = [module.security-groups.red5pro_mysql_sg]
  red5pro_sm_sg_id = [module.security-groups.red5pro_sm_sg,module.security-groups.retailott_support_sg,module.security-groups.internetaccess-sg,module.security-groups.monitoring_access_sg]
  red5pro_terraform_sg_id = [module.security-groups.red5pro_terraform_sg,module.security-groups.internetaccess-sg]
  red5pro_node_sg_id  = join(",",[module.security-groups.red5pro_node_sg,module.security-groups.retail_shops_sg,module.security-groups.retailott_support_sg])
  bucket_name  = local.workspace["bucket_name_for_${data.aws_region.current.name}"]
  s3_bucket_for_lb_logs = local.workspace["bucket_name_for_${data.aws_region.current.name}"]
  s3_bucket_prefix = local.workspace["s3_bucket_prefix_for_${data.aws_region.current.name}"]
  bucket_name_for_statefile = local.workspace["bucket_name_for_statefile_${data.aws_region.current.name}"]
  bucket_folder_path_for_statefile = local.workspace["bucket_folder_path_for_statefile"]
  terraform_state_lock_dynamodb_name = local.workspace["terraform_state_lock_dynamodb_name"]
  bucket_region_for_statefile = local.workspace["bucket_region_for_statefile_${data.aws_region.current.name}"]
  s3_bucket_for_red5pro_logs = local.workspace["s3_bucket_for_red5pro_logs_${data.aws_region.current.name}"]
  s3_bucket_for_red5pro_nodes_logs = local.workspace["s3_bucket_for_red5pro_nodes_logs_${data.aws_region.current.name}"]
  ssl_certificate_domain = local.workspace ["ssl_certificate_domain"]
  red5pro_ssh_key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  mysql_instance_type = local.workspace["mysql_instance_type"]
  mysql_user_name = local.workspace["mysql_user_name"]
  mysql_password = var.mysql_password
  red5pro_image_name = var.red5pro_image_name 
  red5pro_sm_instance_type = local.workspace["red5pro_sm_instance_type"]
  red5pro_sm_volume_size = local.workspace["red5pro_sm_volume_size"]
  red5pro_sm_api_token = var.red5pro_api_token
  red5pro_terraform_image_name = var.red5pro_terraform_image_name
  red5pro_terraform_instance_type = local.workspace["red5pro_terraform_instance_type"]
  red5pro_terraform_volume_size = local.workspace["red5pro_terraform_volume_size"]
  red5pro_terraform_port = local.workspace["red5pro_terraform_port"]
  red5pro_terraform_api_token = var.red5pro_api_token
  red5pro_terraform_parallelism = local.workspace["red5pro_terraform_parallelism"]
  red5pro_node_prefix_name = local.workspace["red5pro_node_prefix_name_for_${data.aws_region.current.name}"]
  red5pro_node_volume_size = local.workspace["red5pro_node_volume_size"]
  red5pro_node_cluster_token = var.red5pro_api_token
  red5pro_node_api_token = var.red5pro_api_token
}

########## SIS Config Server Module #######
module "sis_config" {
  source = ".//modules/sis_config"
  count = local.workspace["create_sis_config_for_${data.aws_region.current.name}"] ? 1 : 0
  env_name = local.workspace["env_name"]
  aws_region = data.aws_region.current.name
  key_name = local.workspace["key_name_for_${data.aws_region.current.name}"]
  service = "sis_config"
  sis_config_name = "main"
  project = local.workspace["project"]
  common_tags = local.common_tags
  environment = local.workspace["env_name"]
  sis_config_instance_type = local.workspace["sis_config_instance_type"]
  sis_config_sg_ids = [module.security-groups.sis_config-sg, module.security-groups.internetaccess-sg] 
  sis_config_subnet_ids = local.workspace["public_subnet_ids_for_${data.aws_region.current.name}"]
  sis_config_ami = local.workspace["sis_config_ami_for_${data.aws_region.current.name}"]
  instance_profile = local.workspace["instance_profile"]
  domain_secret_name = local.workspace["domain_secret_name"]
  domain_admin_user  = local.workspace["domain_admin_user"]
  ADdomain = local.workspace["ADdomain"]
  ADOU = local.workspace["ADOU"]
}
data "aws_region" "current" {}
