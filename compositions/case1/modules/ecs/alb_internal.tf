// Todo: httpのリダイレクト
# アクセス

# ------------------------------
# ALB
# ------------------------------
resource "aws_lb" "internal" {
  name               = "${var.project}-${var.environment}-alb-internal"
  load_balancer_type = "application"
  internal           = true

  security_groups = [
    aws_security_group.alb_internal.id
  ]

  subnets = [
    var.private_subnet_1a_mgr__id,
    var.private_subnet_1c_mgr__id
  ]

  tags = {
    Name = "${var.project}-${var.environment}-alb-internal"
  }
}

# ------------------------------
# SecurityGroup
# ------------------------------
resource "aws_security_group" "alb_internal" {
  name        = "${var.project}-${var.environment}-sg-alb-internal"
  description = "${var.project}-${var.environment}-sg-alb-internal"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg-alb-internal"
  }
}

resource "aws_security_group_rule" "alb_internal_http" {
  security_group_id = aws_security_group.alb_internal.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ------------------------------
# Listener
# ------------------------------
resource "aws_lb_listener" "internal" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.internal.arn

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
resource "aws_lb_listener_rule" "mgr" {
  listener_arn = aws_lb_listener.internal.arn

  # 全てのパスをターゲットグループへフォワードする
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mgr.id
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
resource "aws_lb_target_group" "mgr" {
  name = "${var.project}-${var.environment}-tg-mgr"
  vpc_id = var.vpc_id

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}



