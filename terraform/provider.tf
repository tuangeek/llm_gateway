terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    # docker = {
    #   source = "kreuzwerker/docker"
    #   version = "~> 3.6"
    # }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = var.region
    profile = var.profile != null ? var.profile : null

  dynamic "assume_role" {
    for_each = var.role_session_name == null ? [] : [1]
    content {
      role_arn     = var.assume_role
      session_name = var.role_session_name
    }
  }

  default_tags {
    tags = {
      Environment = var.env
      Project     = "gateway"
    }
  }
}


# provider "docker" {
#   host = "unix:///var/run/docker.sock"
# }
