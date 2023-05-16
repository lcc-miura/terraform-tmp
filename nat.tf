# ------------------------------
# NAT Gateway
# ------------------------------
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.eip_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name = "${var.project}-${var.environment}-nat-1a"
  }
}

resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.eip_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id

  tags = {
    Name = "${var.project}-${var.environment}-nat-1c"
  }
}