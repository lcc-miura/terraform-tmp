# ------------------------------
# VPC
# ------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  lifecycle {
    # terraform destroy時にリソースの破壊を防ぐ
    # prevent_destroy = true
    # 更新をスキップ
    ignore_changes = [
      cidr_block
    ]
  }

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}