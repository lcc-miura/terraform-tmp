# ------------------------------
# ECS Cluster
# ------------------------------
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-${var.environment}-cluster"
}
