# ------------------------------
# Outputs
# ------------------------------
output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1a__id" {
  value = aws_subnet.public_subnet_1a.id
}

output "public_subnet_1c__id" {
  value = aws_subnet.public_subnet_1c.id
}

output "private_subnet_1a_mgr__id" {
  value = aws_subnet.private_subnet_1a_mgr.id
}

output "private_subnet_1c_mgr__id" {
  value = aws_subnet.private_subnet_1c_mgr.id
}