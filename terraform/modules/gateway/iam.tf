resource "aws_iam_role" "execute" {
  name               = "${var.org}-${var.env}-execute-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "execute" {
  role       = aws_iam_role.execute.name
  policy_arn = "arn:${data.aws_partition.current.id}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "task" {
  name               = "${var.org}-${var.env}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "task_policy" {
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "logs:PutLogEvents",
    ]

    resources = [
      aws_cloudwatch_log_group.this.arn,
      "${aws_cloudwatch_log_group.this.arn}/*"
    ]
  }

  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "bedrock:Get*",
      "bedrock:List*",
      "bedrock:CallWithBearerToken",
      "bedrock:BatchDeleteEvaluationJob",
      "bedrock:CreateEvaluationJob",
      "bedrock:CreateGuardrail",
      "bedrock:CreateGuardrailVersion",
      "bedrock:CreateInferenceProfile",
      "bedrock:CreateModelCopyJob",
      "bedrock:CreateModelCustomizationJob",
      "bedrock:CreateModelImportJob",
      "bedrock:CreateModelInvocationJob",
      "bedrock:CreatePromptRouter",
      "bedrock:CreateProvisionedModelThroughput",
      "bedrock:DeleteCustomModel",
      "bedrock:DeleteGuardrail",
      "bedrock:DeleteImportedModel",
      "bedrock:DeleteInferenceProfile",
      "bedrock:DeletePromptRouter",
      "bedrock:DeleteProvisionedModelThroughput",
      "bedrock:StopEvaluationJob",
      "bedrock:StopModelCustomizationJob",
      "bedrock:StopModelInvocationJob",
      "bedrock:TagResource",
      "bedrock:UntagResource",
      "bedrock:UpdateGuardrail",
      "bedrock:UpdateProvisionedModelThroughput",
      "bedrock:ApplyGuardrail",
      "bedrock:InvokeModel",
      "bedrock:InvokeModelWithResponseStream"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task_policy" {
  name   = "${var.org}-${var.env}-gateway-task-role"
  policy = data.aws_iam_policy_document.task_policy.json
}

resource "aws_iam_role_policy_attachment" "task_logs" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}


