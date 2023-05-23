# ------------------------------
# Route Table
# ------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-public-rt"
  }
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-private-rt-1a"
  }
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-private-rt-1c"
  }
}

# ------------------------------
# Route
# ------------------------------
resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_rt_nat_r_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1a.id
}

resource "aws_route" "private_rt_nat_r_1c" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1c.id
}

# ------------------------------
# Route Table Association
# ------------------------------
resource "aws_route_table_association" "public_rt_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_1a_fe" {
  subnet_id      = aws_subnet.private_subnet_1a_fe.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private_rt_1c_fe" {
  subnet_id      = aws_subnet.private_subnet_1c_fe.id
  route_table_id = aws_route_table.private_rt_1c.id
}

resource "aws_route_table_association" "private_subnet_1a_mgr" {
  subnet_id      = aws_subnet.private_subnet_1a_mgr.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private_subnet_1c_mgr" {
  subnet_id      = aws_subnet.private_subnet_1c_mgr.id
  route_table_id = aws_route_table.private_rt_1c.id
}