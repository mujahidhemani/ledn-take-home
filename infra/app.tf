resource "aws_ecs_service" "webserver" {
  name                 = "ledn-web-service"
  cluster              = module.ecs.ecs_cluster_arn
  task_definition      = aws_ecs_task_definition.ledn.arn
  desired_count        = 3
  launch_type          = "FARGATE"
  force_new_deployment = true

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group.arn
    container_name   = "ledn"
    container_port   = 80
  }
  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs-ledn.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "ledn" {
  family                   = "ledn-fargate"
  memory                   = 1024
  cpu                      = 512
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs-role.arn
  tags = {
    Environment = "${terraform.workspace}"
  }
  container_definitions = jsonencode([
    {
      name      = "ledn"
      image     = "086189893235.dkr.ecr.us-east-1.amazonaws.com/ledn:${var.docker_tag}"
      essential = true
      portMappings = [
        {
          containerPort = 80
        },
        {
          containerPort = 22
        }
      ]
    }
  ])
}

resource "aws_security_group" "ecs-ledn" {
  name   = "ledn-ecs-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    protocol  = "-1"
    self      = true
    to_port   = 0
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecs-role" {
  name               = "ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
}

resource "aws_iam_role_policy" "task_execution" {
  name   = "ecs-task-execution"
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