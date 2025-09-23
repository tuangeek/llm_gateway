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
  profile = var.profile

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
