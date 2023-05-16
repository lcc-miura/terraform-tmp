// Todo: httpのリダイレクト

# ------------------------------
# ALB
# ------------------------------
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1c.id
  ]

  tags = {
    Name = "${var.project}-${var.environment}-alb"
  }
}

# ------------------------------
# Listener
# ------------------------------
resource "aws_lb_listener" "listener" {
  port              = "80"
  protocol          = "HTTP"

  load_balancer_arn = aws_lb.alb.arn

  default_action {
    type             = "fixed-response"

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
resource "aws_lb_listener_rule" "main" {
  # ルールを追加するリスナー
  listener_arn = "${aws_lb_listener.listener.arn}"

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  # condition {
  #   field  = "path-pattern"
  #   values = ["*"]
  # }
  condition {
    # host_header {
    #   values = ["*"]
    # }

    path_pattern {
      values = ["*"]
    }
  }
}

# ------------------------------
# SecurityGroup
# ------------------------------
resource "aws_security_group" "alb" {
  name        = "security_group_alb"
  description = "security_group_alb"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-sg-alb"
  }
}

resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  
  cidr_blocks = ["0.0.0.0/0"]
}

