# ------------------------------
# ECS Cluster
# ------------------------------
resource "aws_ecs_cluster" "main" {
  name = "handson"
}