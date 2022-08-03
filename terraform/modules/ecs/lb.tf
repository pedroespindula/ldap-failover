resource "aws_lb" "this" {
  name               = "${var.name}-load-balancer"
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = merge(var.aws_tags, {
    Name = "${var.name}-load-balancer"
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-target-group"
  port        = var.port
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = merge(var.aws_tags, {
    Name = "${var.name}-target-group"
  })
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.port
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
