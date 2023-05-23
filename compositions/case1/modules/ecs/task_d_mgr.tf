# ------------------------------
# Task Definition
# ------------------------------
resource "aws_ecs_task_definition" "mgr" {
  family = "${var.project}-${var.environment}-task-definition-mgr"
  requires_compatibilities = ["FARGATE"]
  cpu    = "256"
  memory = "512"
  network_mode = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn


  container_definitions = jsonencode([
    {
      "name" : "nginx",
      "image" : "${var.account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/my-ecr-repo:latest",
      "essential" : true,
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 80
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

# ------------------------------
# IAM Role
# ------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess" # SSM用
  ]
}

# ------------------------------
# Cloud Watch
# ------------------------------
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/my-task-log-group"
}

resource "aws_cloudwatch_event_rule" "ecs_event_rule" {
  name        = "my-ecs-events"
  description = "ECS task events"

  event_pattern = jsonencode({
    "source"      : ["aws.ecs"],
    "detail-type" : ["ECS Task State Change"],
    "detail"      : {
      "clusterArn": [aws_ecs_cluster.main.arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_events_target" {
  rule      = aws_cloudwatch_event_rule.ecs_event_rule.name
  target_id = "my-ecs-events-target"
  arn       = aws_cloudwatch_log_group.ecs_logs.arn
}