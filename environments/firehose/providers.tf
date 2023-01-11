terraform {
  required_version = ">= 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      managed_by = "terraform"
      repo       = "terraform-cwl-firehose-s3-sample"
      env        = "firehose"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
