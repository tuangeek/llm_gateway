data "aws_vpc" "main" {
  id = var.vpc_id
}
data "aws_region" "current" {}
data "aws_partition" "current" {}

data "aws_elb_service_account" "main" {}
data "aws_availability_zones" "this" {}
data "aws_caller_identity" "current" {}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "${var.org}-${var.env}-private*"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  tags = {
    Name = "${var.org}-${var.env}-public*"
  }
}