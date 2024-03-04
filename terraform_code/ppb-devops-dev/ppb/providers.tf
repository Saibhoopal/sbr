terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.1.0"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.2"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }

  }
}
