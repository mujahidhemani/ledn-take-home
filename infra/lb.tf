resource "aws_lb" "lb" {
  name_prefix        = "ledn"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id, aws_security_group.ecs-ledn.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_security_group" "lb" {
  name        = "lb-frontend-sg"
  description = "Allow inbound traffic to the LB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP port 80 traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS port 443 traffic"
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http-80" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

resource "aws_lb_target_group" "target-group" {
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = module.vpc.vpc_id
  deregistration_delay = "15"
  lifecycle {
    create_before_destroy = true
  }
}