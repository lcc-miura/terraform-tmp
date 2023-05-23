# ------------------------------
# ECS Service
# ------------------------------
resource "aws_ecs_service" "mgr" {
  name            = "${var.project}-${var.environment}-service-mgr"
  depends_on      = [aws_lb_listener_rule.mgr]
  cluster         = aws_ecs_cluster.main.name
  launch_type     = "FARGATE"
  desired_count   = "1" # ECSタスクの起動数
  task_definition = aws_ecs_task_definition.mgr.arn

  network_configuration {
    subnets         = [
      var.private_subnet_1a_mgr__id,
      var.private_subnet_1c_mgr__id
    ]
    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = aws_lb_target_group.mgr.arn
    container_name   = "nginx"
    container_port   = "80"
  }
}

# ------------------------------
# SecurityGroup
# ------------------------------
resource "aws_security_group" "ecs" {
  name        = "${var.project}-${var.environment}-sg-ecs"
  description = "${var.project}-${var.environment}-sg-ecs"

  vpc_id = var.vpc_id

  # イメージPull用にアウトバウンド設定
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg-ecs"
  }
}

# ------------------------------
# SecurityGroup Rule
# ------------------------------
resource "aws_security_group_rule" "ecs_http" {
  security_group_id = aws_security_group.ecs.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  # 同一VPC内からのアクセスのみ許可
  cidr_blocks = ["10.0.0.0/16"]
}

resource "aws_security_group_rule" "ecs_https" {
  security_group_id = aws_security_group.ecs.id

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  # 同一VPC内からのアクセスのみ許可
  cidr_blocks = ["10.0.0.0/16"]
}


