variable "port" {
  default     = null
  description = "Port the listener listens on."
}

variable "protocol" {
  default     = null
  description = "Protocol the listener listens with (e.g. 'HTTP', 'HTTPS')."
}

variable "ssl_policy" {
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "SSL policy for an HTTPS listener. Never sent to AWS for other protocols, which reject it if set."
}

variable "certificate_arn" {
  default     = null
  description = "The ARN of the default ACM certificate for an HTTPS/TLS listener."
}

variable "load_balancer_arn" {
  default     = null
  description = "The ARN of the load balancer this listener is attached to."
}

variable "target_group_arn" {
  default     = null
  description = "The ARN of the target group to forward to, if type is 'forward'."
}

variable "type" {
  default     = "forward"
  description = "Type of the default action (e.g. 'forward' or 'redirect')."
}

variable "redirect" {
  default     = null
  description = "Redirect configuration, if type is 'redirect'."
  type = object({
    port        = string
    protocol    = string
    status_code = optional(string, "HTTP_301")
  })
}

variable "tags" {
  default     = null
  description = "A map of tags to assign to the listener."
}
