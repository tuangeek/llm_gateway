resource "aws_security_group" "ecs" {
  name        = "${var.org}-${var.env}-ecs"
  description = "Security group for ECS"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name = "ecs_sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.org}-${var.env}-alb"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or more restrictive CIDR blocks if ALB is not public
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Or more restrictive CIDR blocks if ALB is not public
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb_sg"
  }
}



# An ingress rule on the ECS security group allows traffic from the ALB's security group.
resource "aws_vpc_security_group_ingress_rule" "allow_alb_to_ecs" {
  security_group_id            = aws_security_group.ecs.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
  description                  = "Allow traffic from ALB to ECS tasks"
}

# An egress rule on the ECS security group allows outbound internet access
# (e.g., for pulling container images or connecting to AWS services).
resource "aws_vpc_security_group_egress_rule" "ecs_to_internet" {
  security_group_id = aws_security_group.ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allows all protocols
}


