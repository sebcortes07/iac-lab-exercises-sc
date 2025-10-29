terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_lb" "lb" {
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.lb_sg.id]

  # Collect all public subnet IDs from aws_subnet.public_subnets (works for both count and for_each)
  subnets = [for s in aws_subnet.public_subnets : s.id]

  tags = {
    Name = format("%s-lb", var.prefix)
  }
}

resource "aws_lb_target_group" "tg" {
  name        = format("%s-lb-tg", var.prefix)
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200,302"
    path                = "/users"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = format("%s-lb-tg", var.prefix)
  }
}

resource "aws_lb_listener" "lb_listener" {
  port              = 80
  protocol          = "HTTP"
  load_balancer_arn = aws_lb.lb.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_security_group" "lb_sg" {
  name        = format("%s-lb-sg", var.prefix)
  description = "Security group for the application Load Balancer - allows HTTP and app traffic"
  vpc_id      = aws_vpc.vpc.id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow application port from the load balancer itself
  ingress {
    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"
    self      = true
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}