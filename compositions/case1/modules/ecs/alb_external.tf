// Todo: 
# サブネット
# 

# ------------------------------
# ALB
# ------------------------------
resource "aws_lb" "external" {
  name               = "${var.project}-${var.environment}-alb-external"
  load_balancer_type = "application"
  internal           = false

  security_groups = [
    aws_security_group.alb_external.id
  ]

  subnets = [
    var.public_subnet_1a__id,
    var.public_subnet_1c__id
  ]

  tags = {
    Name = "${var.project}-${var.environment}-alb-external"
  }
}

# ------------------------------
# SecurityGroup
# ------------------------------
resource "aws_security_group" "alb_external" {
  name        = "${var.project}-${var.environment}-sg-alb-external"
  description = "${var.project}-${var.environment}-sg-alb-external"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg-alb-external"
  }
}

resource "aws_security_group_rule" "alb_external_http" {
  security_group_id = aws_security_group.alb_external.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ------------------------------
# Listener
# ------------------------------
resource "aws_lb_listener" "external" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.external.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

# ------------------------------
# ALB Listener Rule
# ------------------------------
resource "aws_lb_listener_rule" "fe" {
  listener_arn = aws_lb_listener.external.arn

  # 全てのパスをターゲットグループへフォワードする
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fe.id
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# ------------------------------
# ELB Target Group
# ------------------------------
resource "aws_lb_target_group" "fe" {
  name = "${var.project}-${var.environment}-tg-fe"
  vpc_id = var.vpc_id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 3000
    path = "/"
  }
}



