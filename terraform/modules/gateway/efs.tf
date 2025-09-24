resource "aws_efs_file_system" "this" {
  creation_token = "${var.org}-${var.env}"
  tags = {
    Name = "${var.org}-${var.env}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = data.aws_subnets.private.ids[0]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
}