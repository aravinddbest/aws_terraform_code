terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["C:/Users/<___>/.aws/credentials"]
  shared_config_files      = ["C:/Users/<___>/.aws/config"]
  profile                  = "vscode"
}


