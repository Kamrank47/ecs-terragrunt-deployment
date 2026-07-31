output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "http_listener" {
  value = aws_lb_listener.http
}

output "https_listener" {
  value = length(aws_lb_listener.https) > 0 ? aws_lb_listener.https[0] : null
}