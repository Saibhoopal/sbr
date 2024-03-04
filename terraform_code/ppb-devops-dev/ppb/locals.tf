locals {
  common_tags = {
    Organisation = "Paddypower_betfair" 
    Environment  = local.workspace["env_name"]
    Project      = "ppb-ott" 
    aws-inspector = "bypass"
    "Platform:BusinessVertical" = "Retail"
    "Platform:TLA" = "OTT"
    "Platform:CostCode" = "61997"
    "Platform:CreatedBy" = "terraform"
  }
}
