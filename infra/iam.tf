resource "aws_iam_role" "ecs-role" {
  name               = "ledn-web-service-execution-role-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

resource "aws_iam_role_policy" "task_execution" {
  name   = "ledn-execution-policy-${terraform.workspace}"
  role   = aws_iam_role.ecs-role.id
  policy = data.aws_iam_policy_document.task_execution_permissions.json
}

data "aws_iam_policy_document" "task_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_permissions" {
  statement {
    effect = "Allow"

    resources = [
      "*",
    ]

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}