# terraform-aws-alb-listener

Terraform module for a single load balancer listener, forwarding to a
target group or redirecting — kept separate from
[`terraform-aws-alb`](https://github.com/kn47ytv9mv/terraform-aws-alb)
since one load balancer can have several listeners.

## Cost

A listener carries no charge of its own — cost comes from the load
balancer it is attached to (see `terraform-aws-alb`).

## Usage

```hcl
module "https" {
  source = "kn47ytv9mv/alb-listener/aws"

  load_balancer_arn = module.alb.arn
  port              = 443
  protocol          = "HTTPS"

  certificate_arn  = module.certificate.validated_arn
  target_group_arn = module.target_group.arn
}
```

Or directly from this repository:

```hcl
module "http_redirect" {
  source = "github.com/kn47ytv9mv/terraform-aws-alb-listener"

  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"
  type              = "redirect"

  redirect = {
    port     = "443"
    protocol = "HTTPS"
  }
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| aws | ~> 6.61 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| port | Port the listener listens on. | `null` | no |
| protocol | Protocol the listener listens with (e.g. `'HTTP'`, `'HTTPS'`). | `null` | no |
| ssl_policy | SSL policy for an HTTPS listener. Never sent to AWS for other protocols, which reject it if set. | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| certificate_arn | The ARN of the default ACM certificate for an HTTPS/TLS listener. | `null` | no |
| load_balancer_arn | The ARN of the load balancer this listener is attached to. | `null` | no |
| target_group_arn | The ARN of the target group to forward to, if `type` is `'forward'`. | `null` | no |
| type | Type of the default action (e.g. `'forward'` or `'redirect'`). | `"forward"` | no |
| redirect | Redirect configuration, if `type` is `'redirect'` (`port`, `protocol`, and optional `status_code` defaulting to `"HTTP_301"`). | `null` | no |
| tags | A map of tags to assign to the listener. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the listener. |
| arn | The ARN of the listener. |

## License

MIT — see [LICENSE.md](LICENSE.md).
