# ------------------------------
# Elastic IP
# ------------------------------
resource "aws_eip" "eip_1a" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.environment}-eip-1a"
  }
}

resource "aws_eip" "eip_1c" {
  vpc = true

  tags = {
    Name = "${var.project}-${var.environment}-eip-1c"
  }
}