# ------------------------------
# Task Definition
# ------------------------------
resource "aws_ecs_task_definition" "main" {
  family = "handson"

  requires_compatibilities = ["FARGATE"]

  # ECSタスクが使用可能なリソースの上限
  cpu    = "256"
  memory = "512"

  network_mode = "awsvpc"

  # 「nginxを起動し、80ポートを開放する」設定を記述。
  container_definitions = <<EOL
[
  {
    "name": "nginx",
    "image": "nginx:1.14",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
EOL
}