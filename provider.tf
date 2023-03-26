terraform {
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}


provider "aws" {
  alias  = "ap-southeast-2"
  region = "ap-southeast-2"
  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/AdminAccess"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/AdminAccess"
  }
}

provider "aws" {
  region = "us-west-1"
  alias  = "us-west-1"
  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/AdminAccess"
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "us-west-2"
  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/AdminAccess"
  }
}

provider "aws" {
  region = "me-central-1"
  alias  = "me-central-1"
  assume_role {
    # The role ARN within Account B to AssumeRole into. Created in step 1.
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/AdminAccess"
  }
}
