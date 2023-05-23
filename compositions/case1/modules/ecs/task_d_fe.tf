# ------------------------------
# Task Definition fe
# ------------------------------
resource "aws_ecs_task_definition" "fe" {
  family = "${var.project}-${var.environment}-task-definition-fe"

  requires_compatibilities = ["FARGATE"]

  # ECSタスクが使用可能なリソースの上限
  cpu    = "256"
  memory = "512"

  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      "name" : "nextjs",
      "image" : "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/drits-manager-fe-temp:latest",
      "essential" : true,
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group" : "${aws_cloudwatch_log_group.ecs_logs.name}",
          "awslogs-region": "ap-northeast-1",
          "awslogs-stream-prefix": "awslogs-stream-prefix"
        }
      }
    }
  ])
}