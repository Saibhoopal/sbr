
locals {

  env = {
    default = {
      project_name = "ppb-ott"
    }
    dev = {
      env = 1
      env_name = "dev"
      project = "ppb-ott"
      enable_vpn_gateway = false
      bastion_windows_ami_for_eu-west-1 = "ami-0a0be3ac17c6f6371"
      bastion_windows_ami_for_eu-west-2 = "ami-025395061b0b2b9de"
      windows_ami_for_eu-west-1 = "ami-0a0be3ac17c6f6371"
      windows_ami_for_eu-west-2 = "ami-03420b221fbc7d04e"       
      key_name_for_eu-west-1 = "ppb-ott-dev"
      key_name_for_eu-west-2 = "ppb-ott-dev-ldn"

      vpc_id_eu-west-1 = "vpc-063f58409cb608124"
      vpc_id_eu-west-2 = "vpc-06272e67d7d3ae243"
      public_subnet_ids_for_eu-west-1 = ["subnet-0e6840c5899fe8faa", "subnet-02150600f6d67e811"]
      public_subnet_a_for_eu-west-1 = ["subnet-0e6840c5899fe8faa"]
      public_subnet_b_for_eu-west-1 = ["subnet-02150600f6d67e811"]
      public_subnet_ids_for_eu-west-2 = ["subnet-0b52ba40b4862dedc" , "subnet-06df2ec4eb0ba3d5c"]
      public_subnet_a_for_eu-west-2 = ["subnet-0b52ba40b4862dedc"]
      public_subnet_b_for_eu-west-2 = ["subnet-06df2ec4eb0ba3d5c"]
      private_subnet_ids_for_eu-west-1 = ["subnet-0d9be3d25c20b700f", "subnet-007d84494a65e4fd7"] 
      eu-west-1_private_subnet_ids = ["subnet-0d9be3d25c20b700f", "subnet-007d84494a65e4fd7"]
      eu-west-2_private_subnet_ids = ["subnet-0d9be3d25c20b700f", "subnet-007d84494a65e4fd7"]
      private_subnet_ids_for_eu-west-2 = ["",""]
      eu-west-1_private_route_table_ids = ["rtb-0f53b0beba0081772", "rtb-01ef50cedd4899b44"]  
      private_subnet_ids_for_eu-west-1a = ["subnet-0d9be3d25c20b700f"] 
      private_subnet_ids_for_eu-west-1b = ["subnet-007d84494a65e4fd7"]

      vpc_cidr_range_eu-west-1 = ["10.174.44.0/22"]
      vpc_cidr_range_eu-west-2 = ["10.191.0.0/22"]
      bastion_ingress_cidr_eu-west-1 = ["3.10.22.13/32" , "84.20.213.254/32"]
      bastion_egress_cidr_eu-west-1 = ["10.174.45.0/24"]
      bastion_ingress_cidr_eu-west-2 = ["3.10.22.13/32" , "84.20.213.254/32"]
      bastion_egress_cidr_eu-west-2 = ["10.191.0.0/24"]
      public_subnet_cidr_range_eu-west-1 = ["10.174.46.0/24"]
      public_subnet_cidr_range_eu-west-2 = ["10.191.1.0/24"]
      shared_account_cidr_range_eu-west-1 = ["10.175.1.0/24" ,"10.175.3.0/24", "10.175.4.0/24","10.175.5.0/24"]
      shared_account_cidr_range_eu-west-2 = ["10.177.4.0/24"]
      monitoring_subnet_range = ["10.174.32.0/26","10.174.32.64/26","18.203.13.189/32","34.247.2.91/32"]

      ppb_internet_access_pl_eu-west-1 = ["pl-0791f6b1f71f88fd8"]
      ppb_internet_access_pl_eu-west-2 = ["pl-05415ec7304f719ee"]
      ppb_cloudflare_pl_eu-west-1 = ["pl-0c377cb5e5bfdbdc4"]
      ppb_cloudflare_pl_eu-west-2 = ["pl-0deaf81a65c71fe14"]
      ppb_network_pl_eu-west-1 = ["pl-0f14e1cb5d400deed"]
      ppb_network_pl_eu-west-2 = ["pl-02764f8c5b1b4d82d"]
      
      create_bastion_for_eu-west-1 = true
      create_bastion_for_eu-west-2 = true
      create_iam_for_eu-west-1 = true
      create_iam_for_eu-west-2 = false
      create_cinegy_for_eu-west-1 = true
      create_cinegy_for_eu-west-2 = false
      create_cinegy_ae1_main_for_eu-west-1 = true
      create_cinegy_ae1_backup_for_eu-west-1 = true
      create_cinegy_ae2_main_for_eu-west-1 = true
      create_cinegy_ae2_backup_for_eu-west-1 = true
      create_cinegy_ae3_main_for_eu-west-1 = false
      create_cinegy_ae3_backup_for_eu-west-1 = false
      create_cinegy_ae4_main_for_eu-west-1 = false
      create_cinegy_ae4_backup_for_eu-west-1 = false
      create_cinegy_ae5_main_for_eu-west-1 = false
      create_cinegy_ae5_backup_for_eu-west-1 = false
      create_cinegy_ae6_main_for_eu-west-1 = true
      create_cinegy_ae6_backup_for_eu-west-1 = false
      create_cinegy_ae7_main_for_eu-west-1 = true
      create_cinegy_ae7_backup_for_eu-west-1 = false
      create_cinegy_mvwr_main_for_eu-west-1 = true
      create_cinegy_mvwr_backup_for_eu-west-1 = true
      create_cinegy_license_for_eu-west-1 = true

      create_cinegy_ae1_main_for_eu-west-2 = false
      create_cinegy_ae1_backup_for_eu-west-2 = false
      create_cinegy_ae2_main_for_eu-west-2 = false
      create_cinegy_ae2_backup_for_eu-west-2 = false
      create_cinegy_ae3_main_for_eu-west-2 = false
      create_cinegy_ae3_backup_for_eu-west-2 = false
      create_cinegy_ae4_main_for_eu-west-2 = false
      create_cinegy_ae4_backup_for_eu-west-2 = false
      create_cinegy_ae5_main_for_eu-west-2 = false
      create_cinegy_ae5_backup_for_eu-west-2 = false
      create_cinegy_ae6_main_for_eu-west-2 = false
      create_cinegy_ae6_backup_for_eu-west-2 = false
      create_cinegy_ae7_main_for_eu-west-2 = false
      create_cinegy_ae7_backup_for_eu-west-2 = false
      create_cinegy_mvwr_main_for_eu-west-2 = false
      create_cinegy_mvwr_backup_for_eu-west-2 = false
      create_cinegy_license_for_eu-west-2 = false
      create_red5pro_for_eu-west-1 = true
      create_red5pro_for_eu-west-2 = true      
      create_red5pro_blue_for_eu-west-1 = true
      create_red5pro_blue_for_eu-west-2 = false
      create_sis_config_for_eu-west-1 = true
      create_sis_config_for_eu-west-2 = false

      bastion_instance_type_eu-west-1 = "t2.medium"
      bastion_instance_type_eu-west-2 = "t2.medium"
      bastion_eip_assoc_ids_for_eu-west-1 = ["eipalloc-0bd7342e7c52f09ab" , "eipalloc-02e832eec7a51009f"]
      bastion_eip_assoc_ids_for_eu-west-2 = ["eipalloc-09aa63ad4631cd477" , "eipalloc-091762fff99ffd5a2"]
      bucket_name_for_eu-west-1 = "3ptyrell-ppb-ott-dev-ireland"
      bucket_name_for_eu-west-2 = "3ptyrell-ppb-ott-dev-london"
      s3_bucket_prefix_for_eu-west-1 = "LBAccessLogs"
      s3_bucket_prefix_for_eu-west-2 = "LBAccessLogs"
      s3_bucket_name_for_cinegy = "3ptyrell-dev-eu-west-1-cinegy"

       
      cinegy_air_instance_type = "g4dn.xlarge"
      cinegy_multiviewer_instance_type = "g4dn.xlarge"
      cinegy_license_instance_type = "t2.medium"
      instance_profile = "3ptyrell_ppb-ott-dev-ec2-instance-profile"
      Cinegy_AE1Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-0.Config.xml"
      Cinegy_AE1Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-1.Config.xml"

      Cinegy_AE1Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-0.Config.xml"
      Cinegy_AE1Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-1.Config.xml"

      Cinegy_AE2Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-0.Config.xml"
      Cinegy_AE2Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-1.Config.xml"

      Cinegy_AE2Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-0.Config.xml"
      Cinegy_AE2Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-1.Config.xml"

      Cinegy_AE3Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-0.Config.xml"
      Cinegy_AE3Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-1.Config.xml"

      Cinegy_AE3Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-0.Config.xml"
      Cinegy_AE3Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-1.Config.xml"

      Cinegy_AE4Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-0.Config.xml"
      Cinegy_AE4Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-1.Config.xml"

      Cinegy_AE4Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-0.Config.xml"
      Cinegy_AE4Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-1.Config.xml"

      Cinegy_AE5Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-0.Config.xml"
      Cinegy_AE5Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-1.Config.xml"

      Cinegy_AE5Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-0.Config.xml"
      Cinegy_AE5Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-1.Config.xml"

      Cinegy_AE6Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-0.Config.xml"
      Cinegy_AE6Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-1.Config.xml"

      Cinegy_AE6Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-0.Config.xml"
      Cinegy_AE6Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-1.Config.xml"

      Cinegy_AE7Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-0.Config.xml"
      Cinegy_AE7Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-1.Config.xml"

      Cinegy_AE7Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-0.Config.xml"
      Cinegy_AE7Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-1.Config.xml"

      Cinegy_AudioMatrix_Config_S3path = "cinegy-configuration/air-engine/AudioConfig/AudioMatrix.xml"

      Cinegy_Mainmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/Layouts/MainMultiviewerLayout.xml"
      Cinegy_Mainmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/MultiviewerCnfg.xml"

      Cinegy_Backupmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/Layouts/BackUpMultiviewerLayout.xml"
      Cinegy_Backupmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/MultiviewerCnfg.xml"

      ADdomain="corp.ppbplc.com"
      ADOU="OU=OTT,OU=Backend Servers,OU=Retail,OU=ENDPOINTS,DC=corp,DC=ppbplc,DC=com"
      domain_secret_name="domain_join_password"
      domain_admin_user="domain_join_admin_user"
      R53Domain= "retailott-dev.aws.private"
      recordset_for_cinegy_ae1_main = "dev-cinegy-ae1-main"
      recordset_for_cinegy_ae1_backup = "dev-cinegy-ae1-backup"
      recordset_for_cinegy_ae2_main = "dev-cinegy-ae2-main"
      recordset_for_cinegy_ae2_backup = "dev-cinegy-ae2-backup"
      recordset_for_cinegy_ae3_main = "dev-cinegy-ae3-main"
      recordset_for_cinegy_ae3_backup = "dev-cinegy-ae3-backup"
      recordset_for_cinegy_ae4_main = "dev-cinegy-ae4-main"
      recordset_for_cinegy_ae4_backup = "dev-cinegy-ae4-backup"
      recordset_for_cinegy_ae5_main = "dev-cinegy-ae5-main"
      recordset_for_cinegy_ae5_backup = "dev-cinegy-ae5-backup"
      recordset_for_cinegy_ae6_main = "dev-cinegy-ae6-main"
      recordset_for_cinegy_ae6_backup = "dev-cinegy-ae6-backup"
      recordset_for_cinegy_ae7_main = "dev-cinegy-ae7-main"
      recordset_for_cinegy_ae7_backup = "dev-cinegy-ae7-backup"
      recordset_for_cinegy_multiviewer_main = "dev-cinegy-multiviewer-main"
      recordset_for_cinegy_multiviewer_backup = "dev-cinegy-multiviewer-backup"
      eu-west-1_license_Recordset_subdomain_prefix = "dev-cinegy-license"
      eu-west-2_license_Recordset_subdomain_prefix = ""
      cinegy_license_address = "dev-cinegy-license.retailott-dev.aws.private"

      red5pro_sm_eip_allocation_id_a_eu-west-1 = "eipalloc-0e4c90941ac29d207"
      red5pro_sm_eip_allocation_id_b_eu-west-1 = "eipalloc-09ba3b9e10c83bc30"
      red5pro_sm_eip_allocation_id_a_eu-west-2 = "eipalloc-086356b14ff3003c8"
      red5pro_sm_eip_allocation_id_b_eu-west-2 = "eipalloc-0b171b40127b5b35c"
      red5pro_nm_eip_allocation_id_a_eu-west-1 = "eipalloc-089f4e7d590a59ac8"
      red5pro_nm_eip_allocation_id_b_eu-west-1 = "eipalloc-0eea78ee1f32ee995"
      red5pro_nm_eip_allocation_id_a_eu-west-2 = "eipalloc-027b381fc55f89845"
      red5pro_nm_eip_allocation_id_b_eu-west-2 = "eipalloc-090afe773e5d63626"
      red5pro_ts_eip_allocation_id_a_eu-west-1 = "eipalloc-0dd9f431a2dd8d084"
      red5pro_ts_eip_allocation_id_b_eu-west-1 = "eipalloc-0f04bfd429e6f7e05"
      red5pro_ts_eip_allocation_id_a_eu-west-2 = "eipalloc-0c114de824a03dcf2"
      red5pro_ts_eip_allocation_id_b_eu-west-2 = "eipalloc-0dd215e71386b304d"

      sm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0b71c46d6664f750f"
      sm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-02da4e949f80e646c"
      sm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-026ecba53fa227991"
      sm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0ffc0d465eeaac614"
      nm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-07e010f521fddfcf8"
      nm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-08de447e9aa3d6fcc"
      nm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-078b32a50ca5e65ff"
      nm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-045cfc3efe17c0563"
      ts_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-045b0ae662f11544b"
      ts_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-02ffbac22c5c99458"
      ts_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-085bf3dcb07bc0403"
      ts_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0b3057664b2a1bfb9"

      public_subnet_a_for_nlb_eu-west-1 = "subnet-0e6840c5899fe8faa"
      public_subnet_b_for_nlb_eu-west-1 = "subnet-02150600f6d67e811"
      public_subnet_a_for_nlb_eu-west-2 = "subnet-0b52ba40b4862dedc"
      public_subnet_b_for_nlb_eu-west-2 = "subnet-06df2ec4eb0ba3d5c"

      instance_profile_for_nodes = "\"3ptyrell_ppb-ott-dev-ec2-instance-profile\""
      bucket_name_for_statefile_eu-west-1 = "\"3ptyrell-ppb-ott-dev-ireland\"" 
      bucket_name_for_statefile_eu-west-2 = "\"3ptyrell-ppb-ott-dev-london\""
      bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/terraform.tfstate\""
      bucket_region_for_statefile_eu-west-1 = "\"eu-west-1\""
      bucket_region_for_statefile_eu-west-2 = "\"eu-west-2\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-1 = "\"3ptyrell-dev-eu-west-1-red5pro-logs\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-2 = "\"3ptyrell-dev-eu-west-2-red5pro-logs\""
      terraform_state_lock_dynamodb_name = "\"ppb-ott-dev-red5pro-terraform-state-lock-dynamo\""
      s3_bucket_for_red5pro_logs_eu-west-1 = "3ptyrell-dev-eu-west-1-red5pro-logs"
      s3_bucket_for_red5pro_logs_eu-west-2 = "3ptyrell-dev-eu-west-2-red5pro-logs"
      tf_statefile_folder_path = "red5pro-terraform-state-file/terraform.tfstate"

      ssl_certificate_domain = "*.ott.paddypower.com"
      mysql_instance_type = "db.t3.micro"
      mysql_user_name = "smadmin"
      red5pro_sm_instance_type = "m5.xlarge"
      red5pro_sm_volume_size = "100"
      red5pro_terraform_instance_type = "c5.large"
      red5pro_terraform_volume_size = "8"
      red5pro_terraform_port = "8083"
      red5pro_terraform_parallelism = "10"
      red5pro_node_volume_size = "100"    
      red5pro_node_prefix_name_for_eu-west-1 = "green-1red5pro-dev-node"
      red5pro_node_prefix_name_for_eu-west-2 = "green-2red5pro-dev-node"
      tag_organisation = "Paddypower_betfair"
      tag_business_vertical = "Retail"
      tag_tla = "OTT"
      tag_cost_code = "61997"
      tag_createdby = "terraform"
      tag_aws_inspector = "bypass"
      tag_service = "red5pro"

      blue_red5pro_sm_eip_allocation_id_a_eu-west-2 = "eipalloc-0ecb28ab7de02d9ef"
      blue_red5pro_sm_eip_allocation_id_b_eu-west-2 = "eipalloc-01f3b99381a2006dc"
      blue_red5pro_nm_eip_allocation_id_a_eu-west-2 = ""
      blue_red5pro_nm_eip_allocation_id_b_eu-west-2 = ""
      blue_red5pro_ts_eip_allocation_id_a_eu-west-2 = ""
      blue_red5pro_ts_eip_allocation_id_b_eu-west-2 = ""
      blue_sm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-058075dd33f6e644a"
      blue_sm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-09d2684c1b03e5ad8"
      blue_nm_nlb_eip_allocation_id_a_eu-west-2 = ""
      blue_nm_nlb_eip_allocation_id_b_eu-west-2 = ""
      blue_ts_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0c52ab0454d5a54f8"
      blue_ts_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0f55252dfae645b19"
      blue_bucket_name_for_statefile_eu-west-2 = "\"3ptyrell-ppb-ott-dev-london\""
      blue_bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/blue/terraform.tfstate\""
      blue_s3_bucket_for_red5pro_nodes_logs_eu-west-2 = "\"3ptyrell-dev-eu-west-2-red5pro-logs/blue\""
      blue_s3_bucket_for_red5pro_logs_eu-west-2 = "3ptyrell-dev-eu-west-2-red5pro-logs/blue"
      blue_red5pro_node_prefix_name_for_eu-west-2 = "2red5pro-dev-blue-node"

      blue_red5pro_sm_eip_allocation_id_a_eu-west-1 = "eipalloc-0cd3ac27b31897b2d"
      blue_red5pro_sm_eip_allocation_id_b_eu-west-1 = "eipalloc-0e4179d6db06daec3"
      blue_red5pro_nm_eip_allocation_id_a_eu-west-1 = "eipalloc-0621aef6dcda7649b"
      blue_red5pro_nm_eip_allocation_id_b_eu-west-1 = "eipalloc-0bd5d518c89cade9c"
      blue_red5pro_ts_eip_allocation_id_a_eu-west-1 = "eipalloc-0dd09dedbd31b6c34"
      blue_red5pro_ts_eip_allocation_id_b_eu-west-1 = "eipalloc-088efe422199f933a"
      blue_sm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0611fb998e595da12"
      blue_sm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-0ed913d50811384dc"
      blue_nm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0dd9f431a2dd8d084"
      blue_nm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-061406620a74408d7"
      blue_ts_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0c9b62716416bb06a"
      blue_ts_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-042dbc6cc7a4d1327"
      blue_bucket_name_for_statefile_eu-west-1 = "\"3ptyrell-ppb-ott-dev-ireland\""
      blue_bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/blue/terraform.tfstate\""
      blue_s3_bucket_for_red5pro_nodes_logs_eu-west-1 = "\"3ptyrell-dev-eu-west-1-red5pro-logs/blue\""
      blue_s3_bucket_for_red5pro_logs_eu-west-1 = "3ptyrell-dev-eu-west-1-red5pro-logs/blue"
      blue_red5pro_node_prefix_name_for_eu-west-1 = "1red5pro-dev-blue-node"
   
      blue_terraform_state_lock_dynamodb_name = "\"ppb-ott-red5pro-red5-terraform-state-lock-dynamo\""
      blue_env_name = "red5pro"
      blue_red5pro_api_token_eu-west-1 = "udZy7cL8zaY3FCrpppbdeveuwest1"
      blue_red5pro_api_token_eu-west-2 = "udZy7cL8zaY3FCrpppbdeveuwest2blue"

      sis_config_instance_type = "t2.large"
      sis_config_ami_for_eu-west-1 = "ami-0aa0614aedcce8a9d"
      sis_config_ami_for_eu-west-2 = "ami-02d3645f5b7002589"
     
    }

    uat = {
      env = 1
      env_name = "uat"
      project = "ppb-ott"
      enable_vpn_gateway = false
      bastion_windows_ami_for_eu-west-1 = "ami-0a0be3ac17c6f6371"
      bastion_windows_ami_for_eu-west-2 = "ami-03420b221fbc7d04e"
      windows_ami_for_eu-west-1 = "ami-0a0be3ac17c6f6371"
      windows_ami_for_eu-west-2 = "ami-03420b221fbc7d04e"
      key_name_for_eu-west-1 = "ppb-ott-dev"
      key_name_for_eu-west-2 = "ppb-ott-dev-ldn"
      vpc_id_eu-west-1 = "vpc-0ee2e116e4713549d"
      vpc_id_eu-west-2 = "vpc-028128b5c27493117"
      public_subnet_ids_for_eu-west-1 = ["subnet-0c3177dd7284ab8a2", "subnet-07cc09a4af92e0a3e"]
      public_subnet_ids_for_eu-west-2 = ["subnet-074763451be857347", "subnet-0f231151576bb70f0"]
      private_subnet_ids_for_eu-west-1 = ["subnet-09a70f7089006cbab", "subnet-0655081364826b07a"]
      private_subnet_ids_for_eu-west-2 = ["",""]
      private_subnet_ids_for_eu-west-1a = ["subnet-09a70f7089006cbab"]
      private_subnet_ids_for_eu-west-1b = ["subnet-0655081364826b07a"]
      

      vpc_cidr_range_eu-west-1 = ["10.174.216.0/22"]
      vpc_cidr_range_eu-west-2 = ["10.191.4.0/22"]
      bastion_egress_cidr_eu-west-1 = ["10.174.218.0/24"]
      bastion_egress_cidr_eu-west-2 = ["10.191.5.0/24"]
      public_subnet_cidr_range_eu-west-1 = ["10.174.218.0/24"]
      public_subnet_cidr_range_eu-west-2 = ["10.191.5.0/24"]
      shared_account_cidr_range_eu-west-1 = ["10.175.1.0/24" ,"10.175.3.0/24", "10.175.4.0/24","10.175.5.0/24"]
      shared_account_cidr_range_eu-west-2 = ["10.177.4.0/24"]
      monitoring_subnet_range = ["10.174.32.0/26","10.174.32.64/26","18.203.13.189/32","34.247.2.91/32"]
      
      ppb_internet_access_pl_eu-west-1 = ["pl-0791f6b1f71f88fd8"]
      ppb_internet_access_pl_eu-west-2 = ["pl-05415ec7304f719ee"]
      ppb_network_pl_eu-west-1 = ["pl-0f14e1cb5d400deed"]
      ppb_network_pl_eu-west-2 = ["pl-02764f8c5b1b4d82d"]
      ppb_cloudflare_pl_eu-west-1 = ["pl-0c377cb5e5bfdbdc4"]
      ppb_cloudflare_pl_eu-west-2 = ["pl-0deaf81a65c71fe14"]
      
      create_bastion_for_eu-west-1 = true
      create_bastion_for_eu-west-2 = true
      create_iam_for_eu-west-1 = false
      create_iam_for_eu-west-2 = false
      create_cinegy_for_eu-west-1 = true
      create_cinegy_for_eu-west-2 = false
      create_cinegy_ae1_main_for_eu-west-1 = true
      create_cinegy_ae1_backup_for_eu-west-1 = false
      create_cinegy_ae2_main_for_eu-west-1 = true
      create_cinegy_ae2_backup_for_eu-west-1 = false
      create_cinegy_ae3_main_for_eu-west-1 = false
      create_cinegy_ae3_backup_for_eu-west-1 = false
      create_cinegy_ae4_main_for_eu-west-1 = false
      create_cinegy_ae4_backup_for_eu-west-1 = false
      create_cinegy_ae5_main_for_eu-west-1 = false
      create_cinegy_ae5_backup_for_eu-west-1 = false
      create_cinegy_ae6_main_for_eu-west-1 = false
      create_cinegy_ae6_backup_for_eu-west-1 = false
      create_cinegy_ae7_main_for_eu-west-1 = false
      create_cinegy_ae7_backup_for_eu-west-1 = false
      create_cinegy_mvwr_main_for_eu-west-1 = true
      create_cinegy_mvwr_backup_for_eu-west-1 = true
      create_cinegy_license_for_eu-west-1 = true

      create_cinegy_ae1_main_for_eu-west-2 = false
      create_cinegy_ae1_backup_for_eu-west-2 = false
      create_cinegy_ae2_main_for_eu-west-2 = false
      create_cinegy_ae2_backup_for_eu-west-2 = false
      create_cinegy_ae3_main_for_eu-west-2 = false
      create_cinegy_ae3_backup_for_eu-west-2 = false
      create_cinegy_ae4_main_for_eu-west-2 = false
      create_cinegy_ae4_backup_for_eu-west-2 = false
      create_cinegy_ae5_main_for_eu-west-2 = false
      create_cinegy_ae5_backup_for_eu-west-2 = false
      create_cinegy_ae6_main_for_eu-west-2 = false
      create_cinegy_ae6_backup_for_eu-west-2 = false
      create_cinegy_ae7_main_for_eu-west-2 = false
      create_cinegy_ae7_backup_for_eu-west-2 = false
      create_cinegy_mvwr_main_for_eu-west-2 = false
      create_cinegy_mvwr_backup_for_eu-west-2 = false
      create_cinegy_license_for_eu-west-2 = false
      create_red5pro_for_eu-west-1 = false
      create_red5pro_for_eu-west-2 = true      
      create_red5pro_blue_for_eu-west-1 = false
      create_red5pro_blue_for_eu-west-2 = true
      create_sis_config_for_eu-west-1 = true
      create_sis_config_for_eu-west-2 = false


      bastion_instance_type_eu-west-1 = "t2.medium"
      bastion_instance_type_eu-west-2 = "t2.medium"
      bastion_eip_assoc_ids_for_eu-west-1 = ["eipalloc-084525b277c5b8514" , "eipalloc-010d27ca9b849656d"]
      bastion_eip_assoc_ids_for_eu-west-2 = ["eipalloc-0b19160a6ecc2e7ce" , "eipalloc-037f3390563cdd285"]
      bucket_name_for_eu-west-1 = "3ptyrell-ppb-ott-uat-ireland"
      bucket_name_for_eu-west-2 = "3ptyrell-ppb-ott-uat-london"
      s3_bucket_prefix_for_eu-west-1 = "LBAccessLogs"
      s3_bucket_prefix_for_eu-west-2 = "LBAccessLogs"
      s3_bucket_name_for_cinegy = "3ptyrell-uat-eu-west-1-cinegy"  


      cinegy_air_instance_type = "g4dn.xlarge"
      cinegy_multiviewer_instance_type = "g4dn.xlarge"
      cinegy_license_instance_type = "t2.medium"
      instance_profile = "3ptyrell_ppb-ott-dev-ec2-instance-profile"
      Cinegy_AE1Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-0.Config.xml"
      Cinegy_AE1Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-1.Config.xml"

      Cinegy_AE1Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-0.Config.xml"
      Cinegy_AE1Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-1.Config.xml"

      Cinegy_AE2Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-0.Config.xml"
      Cinegy_AE2Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-1.Config.xml"

      Cinegy_AE2Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-0.Config.xml"
      Cinegy_AE2Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-1.Config.xml"

      Cinegy_AE3Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-0.Config.xml"
      Cinegy_AE3Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-1.Config.xml"

      Cinegy_AE3Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-0.Config.xml"
      Cinegy_AE3Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-1.Config.xml"

      Cinegy_AE4Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-0.Config.xml"
      Cinegy_AE4Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-1.Config.xml"

      Cinegy_AE4Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-0.Config.xml"
      Cinegy_AE4Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-1.Config.xml"

      Cinegy_AE5Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-0.Config.xml"
      Cinegy_AE5Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-1.Config.xml"

      Cinegy_AE5Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-0.Config.xml"
      Cinegy_AE5Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-1.Config.xml"

      Cinegy_AE6Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-0.Config.xml"
      Cinegy_AE6Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-1.Config.xml"

      Cinegy_AE6Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-0.Config.xml"
      Cinegy_AE6Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-1.Config.xml"
      
      Cinegy_AE7Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-0.Config.xml"
      Cinegy_AE7Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-1.Config.xml"

      Cinegy_AE7Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-0.Config.xml"
      Cinegy_AE7Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-1.Config.xml"

      Cinegy_AudioMatrix_Config_S3path = "cinegy-configuration/air-engine/AudioConfig/AudioMatrix.xml"

      Cinegy_Mainmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/Layouts/MainMultiviewerLayout.xml"
      Cinegy_Mainmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/MultiviewerCnfg.xml"

      Cinegy_Backupmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/Layouts/BackUpMultiviewerLayout.xml"
      Cinegy_Backupmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/MultiviewerCnfg.xml"

      ADdomain="corp.ppbplc.com"
      ADOU="OU=OTT,OU=Backend Servers,OU=Retail,OU=ENDPOINTS,DC=corp,DC=ppbplc,DC=com"
      domain_secret_name="domain_join_password"
      domain_admin_user="domain_join_admin_user"
      R53Domain= "retailott-dev.aws.private"
      recordset_for_cinegy_ae1_main = "uat-cinegy-ae1-main"
      recordset_for_cinegy_ae1_backup = "uat-cinegy-ae1-backup"
      recordset_for_cinegy_ae2_main = "uat-cinegy-ae2-main"
      recordset_for_cinegy_ae2_backup = "uat-cinegy-ae2-backup"
      recordset_for_cinegy_ae3_main = "uat-cinegy-ae3-main"
      recordset_for_cinegy_ae3_backup = "uat-cinegy-ae3-backup"
      recordset_for_cinegy_ae4_main = "uat-cinegy-ae4-main"
      recordset_for_cinegy_ae4_backup = "uat-cinegy-ae4-backup"
      recordset_for_cinegy_ae5_main = "uat-cinegy-ae5-main"
      recordset_for_cinegy_ae5_backup = "uat-cinegy-ae5-backup"
      recordset_for_cinegy_ae6_main = "uat-cinegy-ae6-main"
      recordset_for_cinegy_ae6_backup = "uat-cinegy-ae6-backup"
      recordset_for_cinegy_ae7_main = "uat-cinegy-ae7-main"
      recordset_for_cinegy_ae7_backup = "uat-cinegy-ae7-backup"
      recordset_for_cinegy_multiviewer_main = "uat-cinegy-multiviewer-main"
      recordset_for_cinegy_multiviewer_backup = "uat-cinegy-multiviewer-backup"
      eu-west-1_license_Recordset_subdomain_prefix = "uat-cinegy-license"
      eu-west-2_license_Recordset_subdomain_prefix = ""
      cinegy_license_address = "uat-cinegy-license.retailott-dev.aws.private"

      red5pro_sm_eip_allocation_id_a_eu-west-1 = "eipalloc-0fdc8302f4384f262"
      red5pro_sm_eip_allocation_id_b_eu-west-1 = "eipalloc-055a002e2a3eb9d18"
      red5pro_sm_eip_allocation_id_a_eu-west-2 = "eipalloc-0c1c3c6e0673c581f"
      red5pro_sm_eip_allocation_id_b_eu-west-2 = "eipalloc-0343c757285398730"
      #red5pro_nm_eip_allocation_id_a_eu-west-1 = "eipalloc-00c7bbdb83ec3a977"
      #red5pro_nm_eip_allocation_id_b_eu-west-1 = "eipalloc-035e0598445e5a043"
      #red5pro_nm_eip_allocation_id_a_eu-west-2 = "eipalloc-0f6011856afc8a735"
      #red5pro_nm_eip_allocation_id_b_eu-west-2 = "eipalloc-0975b0502e70655cb"
      red5pro_ts_eip_allocation_id_a_eu-west-1 = "eipalloc-0cdea56a58a3138d6"
      red5pro_ts_eip_allocation_id_b_eu-west-1 = "eipalloc-09bc1c31f11c4e117"
      red5pro_ts_eip_allocation_id_a_eu-west-2 = "eipalloc-024a35aa0e928e749"
      red5pro_ts_eip_allocation_id_b_eu-west-2 = "eipalloc-0af93a52eaf53eded"

      sm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0ec32aa6674540758"
      sm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-05d5f26e5113d3dc5"
      sm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-039eb1c4cdc54cd6b"
      sm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0294b8b48f0145eb8"
      #nm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-092161f73e49a2e23"
      #nm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-0b24441f94744cc99"
      #nm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0ec75c4459e5a35b5"
      #nm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0643e8e4f584a4292"
      ts_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0a6dbcd613b32351b"
      ts_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-05602283fe84c3e41"
      ts_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-024f800bddbbcf535"
      ts_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-044e9c856fcc31d75"

      public_subnet_a_for_nlb_eu-west-1 = "subnet-0c3177dd7284ab8a2"
      public_subnet_b_for_nlb_eu-west-1 = "subnet-07cc09a4af92e0a3e"
      public_subnet_a_for_nlb_eu-west-2 = "subnet-074763451be857347"
      public_subnet_b_for_nlb_eu-west-2 = "subnet-0f231151576bb70f0"

      instance_profile_for_nodes = "\"3ptyrell_ppb-ott-dev-ec2-instance-profile\""
      bucket_name_for_statefile_eu-west-1 = "\"3ptyrell-ppb-ott-uat-ireland\""
      bucket_name_for_statefile_eu-west-2 = "\"3ptyrell-ppb-ott-uat-london\""
      bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/terraform.tfstate\""
      bucket_region_for_statefile_eu-west-1 = "\"eu-west-1\""
      bucket_region_for_statefile_eu-west-2 = "\"eu-west-2\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-1 = "\"3ptyrell-uat-eu-west-1-red5pro-logs\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-2 = "\"3ptyrell-uat-eu-west-2-red5pro-logs\""
      terraform_state_lock_dynamodb_name = "\"ppb-ott-uat-red5pro-terraform-state-lock-dynamo\""
      s3_bucket_for_red5pro_logs_eu-west-1 = "3ptyrell-uat-eu-west-1-red5pro-logs"
      s3_bucket_for_red5pro_logs_eu-west-2 = "3ptyrell-uat-eu-west-2-red5pro-logs"

      ssl_certificate_domain = "*.ott.paddypower.com"
      mysql_instance_type = "db.t3.micro"
      mysql_user_name = "smadmin"
      red5pro_sm_instance_type = "m5.xlarge"
      red5pro_sm_volume_size = "100"
      red5pro_terraform_instance_type = "c5.large"
      red5pro_terraform_volume_size = "8"
      red5pro_terraform_port = "8083"
      red5pro_terraform_parallelism = "10"
      red5pro_node_volume_size = "100"
      red5pro_node_prefix_name_for_eu-west-1 = "1red5pro-uat-node"
      red5pro_node_prefix_name_for_eu-west-2 = "2red5pro-uat-node"
      tag_organisation = "Paddypower_betfair"
      tag_business_vertical = "Retail"
      tag_tla = "OTT"
      tag_cost_code = "61997"
      tag_createdby = "terraform"
      tag_aws_inspector = "bypass"
      tag_service = "red5pro"

      blue_red5pro_sm_eip_allocation_id_a_eu-west-2 = "eipalloc-05dd231709870f521"
      blue_red5pro_sm_eip_allocation_id_b_eu-west-2 = "eipalloc-0d4d9f43f651b4b2b"
      blue_red5pro_nm_eip_allocation_id_a_eu-west-2 = "eipalloc-0149e52666d5f4998"
      blue_red5pro_nm_eip_allocation_id_b_eu-west-2 = "eipalloc-0aab2ff17e6a2f028"
      blue_red5pro_ts_eip_allocation_id_a_eu-west-2 = "eipalloc-0a95c011bcae861c5"
      blue_red5pro_ts_eip_allocation_id_b_eu-west-2 = "eipalloc-06d3380e64c31e4b4"
      blue_sm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-06525e12e3d57b41e"
      blue_sm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0bb73652448dccd79"
      blue_nm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0c4de9b888f7cbd82"
      blue_nm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0626bbd6d2d64013f"
      blue_ts_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0aa225467ae637665"
      blue_ts_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-02635f23822026ace"
      blue_bucket_name_for_statefile_eu-west-2 = "\"3ptyrell-ppb-ott-uat-london\""
      blue_bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/blue/terraform.tfstate\""
      blue_s3_bucket_for_red5pro_nodes_logs_eu-west-2 = "\"3ptyrell-uat-eu-west-2-red5pro-logs/blue\""
      blue_s3_bucket_for_red5pro_logs_eu-west-2 = "3ptyrell-uat-eu-west-2-red5pro-logs/blue"
      blue_red5pro_node_prefix_name_for_eu-west-2 = "blue-2red5pro-uat-node"

      blue_red5pro_sm_eip_allocation_id_a_eu-west-1 = ""
      blue_red5pro_sm_eip_allocation_id_b_eu-west-1 = ""
      blue_red5pro_nm_eip_allocation_id_a_eu-west-1 = ""
      blue_red5pro_nm_eip_allocation_id_b_eu-west-1 = ""
      blue_red5pro_ts_eip_allocation_id_a_eu-west-1 = ""
      blue_red5pro_ts_eip_allocation_id_b_eu-west-1 = ""
      blue_sm_nlb_eip_allocation_id_a_eu-west-1 = ""
      blue_sm_nlb_eip_allocation_id_b_eu-west-1 = ""
      blue_nm_nlb_eip_allocation_id_a_eu-west-1 = ""
      blue_nm_nlb_eip_allocation_id_b_eu-west-1 = ""
      blue_ts_nlb_eip_allocation_id_a_eu-west-1 = ""
      blue_ts_nlb_eip_allocation_id_b_eu-west-1 = ""
      blue_bucket_name_for_statefile_eu-west-1 = "\"3ptyrell-ppb-ott-uat-ireland\""
      blue_bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/blue/terraform.tfstate\""
      blue_s3_bucket_for_red5pro_nodes_logs_eu-west-1 = "\"3ptyrell-uat-eu-west-1-red5pro-logs/blue\""
      blue_s3_bucket_for_red5pro_logs_eu-west-1 = "3ptyrell-uat-eu-west-1-red5pro-logs/blue"
      blue_red5pro_node_prefix_name_for_eu-west-1 = "blue-1red5pro-uat-node"

      blue_terraform_state_lock_dynamodb_name = "\"ppb-ott-uat-blue-red5-terraform-state-lock-dynamo\""
      blue_env_name = "uat-blue"
      blue_red5pro_api_token_eu-west-1 = "udZy7cL8zaY3FCrpppbuateuwest1blue"
      blue_red5pro_api_token_eu-west-2 = "udZy7cL8zaY3FCrpppbuateuwest2blue"


      sis_config_instance_type = "t2.large"
      sis_config_ami_for_eu-west-1 = "ami-0aa0614aedcce8a9d"
      sis_config_ami_for_eu-west-2 = "ami-02d3645f5b7002589"
      
    }

    prod = {
      env = 1
      env_name = "prod"
      project = "ppb-ott"
      enable_vpn_gateway = false
      bastion_windows_ami_for_eu-west-1 = "ami-03c230b03596fc89c"
      bastion_windows_ami_for_eu-west-2 = "ami-0d3096dad572f63bc"
      windows_ami_for_eu-west-1 = "ami-03c230b03596fc89c"
      windows_ami_for_eu-west-2 = "ami-0d3096dad572f63bc"
      key_name_for_eu-west-1 = "ppb-ott-prod"
      key_name_for_eu-west-2 = "ppb-ott-prod-ldn"

      vpc_id_eu-west-1 = "vpc-069c23bd45c6936c5"
      vpc_id_eu-west-2 = "vpc-015beea0027307428"
      public_subnet_ids_for_eu-west-1 = ["subnet-0b3ce1dec414eac1b","subnet-0bae2d003bddeff2a"]
      public_subnet_ids_for_eu-west-2 = ["subnet-0c308f683e9a831b5","subnet-070165b32144a6a1f"]
      private_subnet_ids_for_eu-west-1 = ["subnet-0b0b54bcdaf688676","subnet-0227678aa18f714b1"]
      eu-west-1_public_subnet_range = ["10.175.166.0/25","10.175.166.128/25" ]
      eu-west-2_public_subnet_range = ["10.177.1.0/25","10.177.1.128/25"]
      private_subnet_ids_for_eu-west-2 = ["subnet-0ac2799e3f5729866","subnet-08c406a884676974b"]
      private_subnet_ids_for_eu-west-1a = ["subnet-0b0b54bcdaf688676"] 
      private_subnet_ids_for_eu-west-1b = ["subnet-0227678aa18f714b1"]

      vpc_cidr_range_eu-west-1 = ["10.175.164.0/22"]
      vpc_cidr_range_eu-west-2 = ["10.177.0.0/22"]
      bastion_ingress_cidr_eu-west-1 = ["3.10.22.13/32" , "84.20.213.254/32"]
      bastion_egress_cidr_eu-west-1 = ["10.174.166.0/24"]
      bastion_ingress_cidr_eu-west-2 = ["3.10.22.13/32" , "84.20.213.254/32"]
      bastion_egress_cidr_eu-west-2 = ["10.177.1.0/25"]
      public_subnet_cidr_range_eu-west-1 = ["10.175.166.0/25"]
      public_subnet_cidr_range_eu-west-2 = ["10.177.1.0/25"]
      shared_account_cidr_range_eu-west-1 = ["10.175.1.0/24" ,"10.175.3.0/24", "10.175.4.0/24","10.175.5.0/24"]
      shared_account_cidr_range_eu-west-2 = ["10.177.4.0/24"]
      monitoring_subnet_range = ["10.175.251.0/26","10.175.251.64/26","18.203.13.189/32","34.247.2.91/32"]

      ppb_internet_access_pl_eu-west-1 = ["pl-0791f6b1f71f88fd8"]
      ppb_internet_access_pl_eu-west-2 = ["pl-05415ec7304f719ee"]
      ppb_cloudflare_pl_eu-west-1 = ["pl-0c377cb5e5bfdbdc4"]
      ppb_cloudflare_pl_eu-west-2 = ["pl-0deaf81a65c71fe14"]
      ppb_network_pl_eu-west-1 = ["pl-0f14e1cb5d400deed"]
      ppb_network_pl_eu-west-2 = ["pl-02764f8c5b1b4d82d"]

      create_bastion_for_eu-west-1 = true
      create_bastion_for_eu-west-2 = true
      create_iam_for_eu-west-1 = true
      create_iam_for_eu-west-2 = false
      create_cinegy_for_eu-west-1 = true
      create_cinegy_for_eu-west-2 = false
      create_cinegy_ae1_main_for_eu-west-1 = true
      create_cinegy_ae1_backup_for_eu-west-1 = true
      create_cinegy_ae2_main_for_eu-west-1 = true
      create_cinegy_ae2_backup_for_eu-west-1 = true
      create_cinegy_ae3_main_for_eu-west-1 = true
      create_cinegy_ae3_backup_for_eu-west-1 = true
      create_cinegy_ae4_main_for_eu-west-1 = true
      create_cinegy_ae4_backup_for_eu-west-1 = true
      create_cinegy_ae5_main_for_eu-west-1 = true
      create_cinegy_ae5_backup_for_eu-west-1 = true
      create_cinegy_ae6_main_for_eu-west-1 = true
      create_cinegy_ae6_backup_for_eu-west-1 = true
      create_cinegy_ae7_main_for_eu-west-1 = true
      create_cinegy_ae7_backup_for_eu-west-1 = true
      create_cinegy_mvwr_main_for_eu-west-1 = true
      create_cinegy_mvwr_backup_for_eu-west-1 = true
      create_cinegy_license_for_eu-west-1 = true

      create_cinegy_ae1_main_for_eu-west-2 = false
      create_cinegy_ae1_backup_for_eu-west-2 = false
      create_cinegy_ae2_main_for_eu-west-2 = false
      create_cinegy_ae2_backup_for_eu-west-2 = false
      create_cinegy_ae3_main_for_eu-west-2 = false
      create_cinegy_ae3_backup_for_eu-west-2 = false
      create_cinegy_ae4_main_for_eu-west-2 = false
      create_cinegy_ae4_backup_for_eu-west-2 = false
      create_cinegy_ae5_main_for_eu-west-2 = false
      create_cinegy_ae5_backup_for_eu-west-2 = false
      create_cinegy_ae6_main_for_eu-west-2 = false
      create_cinegy_ae6_backup_for_eu-west-2 = false
      create_cinegy_ae7_main_for_eu-west-2 = false
      create_cinegy_ae7_backup_for_eu-west-2 = false
      create_cinegy_mvwr_main_for_eu-west-2 = false
      create_cinegy_mvwr_backup_for_eu-west-2 = false
      create_cinegy_license_for_eu-west-2 = false
      create_red5pro_for_eu-west-1 = true
      create_red5pro_for_eu-west-2 = true  
      create_sis_config_for_eu-west-1 = true
      create_sis_config_for_eu-west-2 = false    

      bastion_instance_type_eu-west-1 = "t2.medium"
      bastion_instance_type_eu-west-2 = "t2.medium"
      bastion_eip_assoc_ids_for_eu-west-1 = ["eipalloc-07abaa9fdc76e239d" , "eipalloc-00ab30f9e6f07a7c6"]
      bastion_eip_assoc_ids_for_eu-west-2 = ["eipalloc-00471d26eacadd61d" , "eipalloc-05e386eb7bbe5c4a2"]
      bucket_name_for_eu-west-1 = "3ptyrell-ppb-ott-prod-ireland"
      bucket_name_for_eu-west-2 = "3ptyrell-ppb-ott-prod-london"
      s3_bucket_prefix_for_eu-west-1 = "LBAccessLogs"
      s3_bucket_prefix_for_eu-west-2 = "LBAccessLogs"
      s3_bucket_name_for_cinegy = "3ptyrell-prod-eu-west-1-cinegy"

      cinegy_air_instance_type = "g4dn.xlarge"
      cinegy_multiviewer_instance_type = "g4dn.xlarge"
      cinegy_license_instance_type = "t2.medium"
      instance_profile = "3ptyrell_ppb-ott-prod-ec2-instance-profile"
      Cinegy_AE1Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-0.Config.xml"
      Cinegy_AE1Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Main/Instance-1.Config.xml"

      Cinegy_AE1Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-0.Config.xml"
      Cinegy_AE1Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine1Backup/Instance-1.Config.xml"

      Cinegy_AE2Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-0.Config.xml"
      Cinegy_AE2Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Main/Instance-1.Config.xml"

      Cinegy_AE2Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-0.Config.xml"
      Cinegy_AE2Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine2Backup/Instance-1.Config.xml"

      Cinegy_AE3Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-0.Config.xml"
      Cinegy_AE3Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Main/Instance-1.Config.xml"

      Cinegy_AE3Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-0.Config.xml"
      Cinegy_AE3Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine3Backup/Instance-1.Config.xml"

      Cinegy_AE4Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-0.Config.xml"
      Cinegy_AE4Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Main/Instance-1.Config.xml"

      Cinegy_AE4Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-0.Config.xml"
      Cinegy_AE4Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine4Backup/Instance-1.Config.xml"

      Cinegy_AE5Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-0.Config.xml"
      Cinegy_AE5Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Main/Instance-1.Config.xml"

      Cinegy_AE5Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-0.Config.xml"
      Cinegy_AE5Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine5Backup/Instance-1.Config.xml"

      Cinegy_AE6Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-0.Config.xml"
      Cinegy_AE6Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Main/Instance-1.Config.xml"

      Cinegy_AE6Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-0.Config.xml"
      Cinegy_AE6Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine6Backup/Instance-1.Config.xml"
      
      Cinegy_AE7Main_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-0.Config.xml"
      Cinegy_AE7Main_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Main/Instance-1.Config.xml"

      Cinegy_AE7Backup_Config_0_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-0.Config.xml"
      Cinegy_AE7Backup_Config_1_S3path = "cinegy-configuration/air-engine/AirEngine7Backup/Instance-1.Config.xml"

      Cinegy_AudioMatrix_Config_S3path = "cinegy-configuration/air-engine/AudioConfig/AudioMatrix.xml"

      Cinegy_Mainmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/Layouts/MainMultiviewerLayout.xml"
      Cinegy_Mainmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerMain/MultiviewerCnfg.xml"

      Cinegy_Backupmvwr_Layout_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/Layouts/BackUpMultiviewerLayout.xml"
      Cinegy_Backupmvwr_Config_S3path = "cinegy-configuration/multiviewer/MultiviewerBackup/MultiviewerCnfg.xml"

      ADdomain="corp.ppbplc.com"
      ADOU="OU=OTT,OU=Backend Servers,OU=Retail,OU=ENDPOINTS,DC=corp,DC=ppbplc,DC=com"
      domain_secret_name="domain_join_password"
      domain_admin_user="domain_join_admin_user"
      R53Domain= "retailott-prod.aws.private"
      recordset_for_cinegy_ae1_main = "prod-cinegy-ae1-main"
      recordset_for_cinegy_ae1_backup = "prod-cinegy-ae1-backup"
      recordset_for_cinegy_ae2_main = "prod-cinegy-ae2-main"
      recordset_for_cinegy_ae2_backup = "prod-cinegy-ae2-backup"
      recordset_for_cinegy_ae3_main = "prod-cinegy-ae3-main"
      recordset_for_cinegy_ae3_backup = "prod-cinegy-ae3-backup"
      recordset_for_cinegy_ae4_main = "prod-cinegy-ae4-main"
      recordset_for_cinegy_ae4_backup = "prod-cinegy-ae4-backup"
      recordset_for_cinegy_ae5_main = "prod-cinegy-ae5-main"
      recordset_for_cinegy_ae5_backup = "prod-cinegy-ae5-backup"
      recordset_for_cinegy_ae6_main = "prod-cinegy-ae6-main"
      recordset_for_cinegy_ae6_backup = "prod-cinegy-ae6-backup"
      recordset_for_cinegy_ae7_main = "prod-cinegy-ae7-main"
      recordset_for_cinegy_ae7_backup = "prod-cinegy-ae7-backup"
      recordset_for_cinegy_multiviewer_main = "prod-cinegy-multiviewer-main"
      recordset_for_cinegy_multiviewer_backup = "prod-cinegy-multiviewer-backup"
      eu-west-1_license_Recordset_subdomain_prefix = "ireland-cinegy-license1"
      eu-west-2_license_Recordset_subdomain_prefix = "london-cinegy-license1"
      cinegy_license_address = "ireland-cinegy-license1.retailott-prod.aws.private"

      red5pro_sm_eip_allocation_id_a_eu-west-1 = "eipalloc-0ccf172a155dc076e"
      red5pro_sm_eip_allocation_id_b_eu-west-1 = "eipalloc-00cff64a52113dc93"
      red5pro_sm_eip_allocation_id_a_eu-west-2 = "eipalloc-0bb539d7c4c885ad0"
      red5pro_sm_eip_allocation_id_b_eu-west-2 = "eipalloc-0921f22a9b2aa92a1"
      red5pro_ts_eip_allocation_id_a_eu-west-1 = "eipalloc-029f3aecc6e16ce2f"
      red5pro_ts_eip_allocation_id_b_eu-west-1 = "eipalloc-09ee33dbf7c4dcada"
      red5pro_ts_eip_allocation_id_a_eu-west-2 = "eipalloc-0f669e0371ecba403"
      red5pro_ts_eip_allocation_id_b_eu-west-2 = "eipalloc-03497e028aa2ac277"

      sm_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-08b71b716ba8d63b2"
      sm_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-0eb96812d0051f38a"
      sm_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0ff988f8406979bc8"
      sm_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-0bffaccaef899c965"
      ts_nlb_eip_allocation_id_a_eu-west-1 = "eipalloc-0e0727368c67f6e4c"
      ts_nlb_eip_allocation_id_b_eu-west-1 = "eipalloc-0e3f05e3593687010"
      ts_nlb_eip_allocation_id_a_eu-west-2 = "eipalloc-0ccfd33882e2d4354"
      ts_nlb_eip_allocation_id_b_eu-west-2 = "eipalloc-02fa2e4ee79f8e9c9"

      public_subnet_a_for_nlb_eu-west-1 = "subnet-0b3ce1dec414eac1b"
      public_subnet_b_for_nlb_eu-west-1 = "subnet-0bae2d003bddeff2a"
      public_subnet_a_for_nlb_eu-west-2 = "subnet-0c308f683e9a831b5"
      public_subnet_b_for_nlb_eu-west-2 = "subnet-070165b32144a6a1f"

      instance_profile_for_nodes = "\"3ptyrell_ppb-ott-prod-ec2-instance-profile\""
      bucket_name_for_statefile_eu-west-1 = "\"3ptyrell-ppb-ott-prod-ireland\"" 
      bucket_name_for_statefile_eu-west-2 = "\"3ptyrell-ppb-ott-prod-london\""
      bucket_folder_path_for_statefile = "\"red5pro-terraform-state-file/terraform.tfstate\""
      bucket_region_for_statefile_eu-west-1 = "\"eu-west-1\""
      bucket_region_for_statefile_eu-west-2 = "\"eu-west-2\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-1 = "\"3ptyrell-prod-eu-west-1-red5pro-logs\""
      s3_bucket_for_red5pro_nodes_logs_eu-west-2 = "\"3ptyrell-prod-eu-west-2-red5pro-logs\""
      terraform_state_lock_dynamodb_name = "\"ppb-ott-dev-red5pro-terraform-state-lock-dynamo\""
      s3_bucket_for_red5pro_logs_eu-west-1 = "3ptyrell-prod-eu-west-1-red5pro-logs"
      s3_bucket_for_red5pro_logs_eu-west-2 = "3ptyrell-prod-eu-west-2-red5pro-logs"

      ssl_certificate_domain = "sm-ott.paddypower.com"
      mysql_instance_type = "db.t3.micro"
      mysql_user_name = "smadmin"
      red5pro_sm_instance_type = "m5.xlarge"
      red5pro_sm_volume_size = "100"
      red5pro_terraform_instance_type = "c5.large"
      red5pro_terraform_volume_size = "8"
      red5pro_terraform_port = "8083"
      red5pro_terraform_parallelism = "10"
      red5pro_node_volume_size = "100"
      red5pro_node_prefix_name_for_eu-west-1 = "1red5pro-prod-node"
      red5pro_node_prefix_name_for_eu-west-2 = "2red5pro-prod-node"
      tag_organisation = "Paddypower_betfair"
      tag_business_vertical = "Retail"
      tag_tla = "OTT"
      tag_cost_code = "SN61997"
      tag_createdby = "terraform"
      tag_aws_inspector = "bypass"
      tag_service = "red5pro"

      sis_config_instance_type = "t2.large"
      sis_config_ami_for_eu-west-1 = "ami-0aa0614aedcce8a9d"
      sis_config_ami_for_eu-west-2 = "ami-02d3645f5b7002589"

    }
  }
  workspace = merge(local.env["default"], local.env[terraform.workspace])
}
