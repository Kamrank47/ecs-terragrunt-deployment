resource "aws_lb" "main" {
  name               = "${var.environment}-nestjs-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.environment == "prod" ? true : false

  dynamic "access_logs" {
    for_each = var.log_bucket != "" ? [1] : []
    content {
      bucket  = var.log_bucket
      prefix  = var.environment
      enabled = true
    }
  }

  tags = {
    Name = "${var.environment}-nestjs-app-alb"
  }
}

resource "aws_lb_target_group" "app" {
  name        = "${var.environment}-nestjs-app-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/api/health-check" # Must match your API endpoint
    port                = "traffic-port"
    timeout             = 5
    healthy_threshold   = 2 # Reduced for faster registration
    unhealthy_threshold = 2
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
    enabled         = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [aws_lb.main, aws_lb_target_group.app]
}

locals {
  create_https     = var.enable_https ? 1 : 0
  create_api_rules = var.enable_api_rules && var.enable_https ? 1 : 0
}

resource "aws_lb_listener" "https" {
  count             = local.create_https
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [aws_lb.main, aws_lb_target_group.app]
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  count        = local.create_https
  listener_arn = aws_lb_listener.http.arn

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

resource "aws_lb_listener_rule" "redirect_api_to_https" {
  count        = local.create_api_rules
  listener_arn = aws_lb_listener.http.arn

  action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.api_domain_name]
    }
  }
}

resource "aws_lb_listener_rule" "https_forward_api" {
  count        = local.create_api_rules
  listener_arn = aws_lb_listener.https[0].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    host_header {
      values = [var.api_domain_name]
    }
  }
}