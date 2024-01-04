terraform {
  required_version = "1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.20.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = "sandbox"
}

terraform {
  backend "s3" {
    bucket = "backstage-bucket"
    key    = "aws-lambda/post-backstage-template-4/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

data "aws_ecr_image" "this" {
  repository_name = "post-backstage-template-4"
  most_recent     = true
}

locals {
  account = data.aws_caller_identity.current.account_id
}

module "lambda_function" {
  source                                  = "terraform-aws-modules/lambda/aws"
  version                                 = "6.0.1"
  function_name                           = "post-backstage-template-4"
  description                             = "post-backstage-template-4"
  timeout                                 = 100
  cloudwatch_logs_retention_in_days       = 5
  ignore_source_code_hash                 = true
  create_role                             = true
  create_current_version_allowed_triggers = false
  create_function                         = true
  create_package                          = false
  image_uri                               = "222222222222.dkr.ecr.us-east-1.amazonaws.com/post-backstage-template-4:${element(data.aws_ecr_image.this.image_tags, 0)}"
  package_type                            = "Image"
  memory_size                             = 256
}
