# VPC
resource "aws_vpc" "healthcare-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.healthcare-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_private_1" {
  vpc_id                  = aws_vpc.healthcare-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.healthcare-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS

resource "aws_ecs_task_definition" "healthcare" {
  family = "healthcare"
  container_definitions = jsonencode([
    {
      name      = "patient"
      image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:patient-app"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    },
    {
      name      = "appointment"
      image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:appointment-app"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3001
          hostPort      = 3001
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-east-1a, us-east-1b]"
  }
}