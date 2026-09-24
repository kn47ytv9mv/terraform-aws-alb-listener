mock_provider "aws" {}

run "forward_action_has_no_redirect_block" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example/0123456789abcdef"
    port              = 443
    protocol          = "HTTPS"
    certificate_arn   = "arn:aws:acm:us-east-1:123456789012:certificate/0123456789abcdef"
    target_group_arn  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/0123456789abcdef"
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].type == "forward"
    error_message = "type should default to 'forward'."
  }

  assert {
    condition     = length(aws_lb_listener.resource.default_action[0].redirect) == 0
    error_message = "The redirect block should be absent for a forward action."
  }

  assert {
    condition     = aws_lb_listener.resource.ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "ssl_policy should default to a modern TLS policy."
  }
}

run "redirect_action_sets_redirect_block" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example/0123456789abcdef"
    port              = 80
    protocol          = "HTTP"
    type              = "redirect"

    redirect = {
      port     = "443"
      protocol = "HTTPS"
    }
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].type == "redirect"
    error_message = "type = 'redirect' should be passed through."
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].redirect[0].status_code == "HTTP_301"
    error_message = "redirect.status_code should default to 'HTTP_301' when not supplied."
  }

  assert {
    condition     = aws_lb_listener.resource.default_action[0].redirect[0].port == "443"
    error_message = "redirect.port should pass through."
  }
}

run "readme_https_forward" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example/0123456789abcdef"
    port              = 443
    protocol          = "HTTPS"

    certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/0123456789abcdef"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/example/0123456789abcdef"
  }
}

run "readme_http_redirect" {
  command = plan

  variables {
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/example/0123456789abcdef"
    port              = 80
    protocol          = "HTTP"
    type              = "redirect"

    redirect = {
      port     = "443"
      protocol = "HTTPS"
    }
  }
}
