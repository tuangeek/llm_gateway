resource "aws_s3_bucket" "lb_logs" {
  bucket = "${var.org}-${var.env}-lb-logs"
}

# give alb access to write logs to s3
data "aws_iam_policy_document" "allow_load_balancer_write" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:${data.aws_partition.current.id}:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.lb_logs.arn}/*",
      "${aws_s3_bucket.lb_logs.arn}/${var.org}-${var.env}-lb/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
    ]
  }

  statement {
    actions = [
      "s3:PutObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    resources = ["${aws_s3_bucket.lb_logs.arn}/*"]
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    resources = [aws_s3_bucket.lb_logs.arn]
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.lb_logs.id
  policy = data.aws_iam_policy_document.allow_load_balancer_write.json
}