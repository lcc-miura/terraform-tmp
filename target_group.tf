# ------------------------------
# ELB Target Group
# ------------------------------
resource "aws_lb_target_group" "main" {
  name = "handson"

  vpc_id = "${aws_vpc.vpc.id}"

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

