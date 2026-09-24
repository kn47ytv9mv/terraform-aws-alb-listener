resource "aws_lb_listener" "resource" {
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = var.certificate_arn
  load_balancer_arn = var.load_balancer_arn

  tags = var.tags

  default_action {
    target_group_arn = var.target_group_arn
    type             = var.type

    dynamic "redirect" {
      for_each = var.redirect[*]

      content {
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        status_code = redirect.value.status_code
      }
    }
  }
}

output "id" {
  description = "The ID of the listener."
  value       = aws_lb_listener.resource.id
}

output "arn" {
  description = "The ARN of the listener."
  value       = aws_lb_listener.resource.arn
}
