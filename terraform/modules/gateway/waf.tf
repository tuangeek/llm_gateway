resource "aws_wafv2_web_acl" "this" {
  name        = "${var.org}-${var.env}-waf"
  description = "Firewall for alb"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.org}-${var.env}-metrics"
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = local.public_paths
    content {
      name     = "allow-${replace(rule.value, "/", "-")}"  # Unique name for each rule
      priority = index(local.public_paths, rule.value) + 1 # Assign priority

      action {
        allow {}
      }

      statement {
        byte_match_statement {
          search_string = rule.value
          field_to_match {
            uri_path {}
          }
          text_transformation {
            priority = index(local.public_paths, rule.value) + 1
            type     = "NONE"
          }
          positional_constraint = "STARTS_WITH" # or EXACTLY, CONTAINS, etc.
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "allow-${index(local.public_paths, rule.value) + 1}-metric"
        sampled_requests_enabled   = true
      }
    }
  }

}