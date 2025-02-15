# VPC
resource "aws_vpc" "healthcare-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_private_1" {
  vpc_id                  = aws_vpc.main.id
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
resource "aws_ecs_cluster" "healthcare-ecs" {
  name = "hcl-hackathon-healthcare"
}

resource "aws_ecs_task_definition" "patient_service" {
  family                = "patient-service"
  execution_role_arn    = "arn:aws:iam::539935451710:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  task_role_arn         = "arn:aws:iam::539935451710:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([{
    name      = "patient-service"
    image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:patient-app"
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
        protocol      = "tcp"
      }
    ]
    }])
}

resource "aws_ecs_task_definition" "appointment_service" {
  family                = "appointment-service"
  execution_role_arn    = "arn:aws:iam::539935451710:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  task_role_arn         = "arn:aws:iam::539935451710:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([{
    name      = "appointment-service"
    image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:appointment-app"
    portMappings = [
      {
        containerPort = 3001
        hostPort      = 3001
        protocol      = "tcp"
      }
    ]
    }])
}

resource "aws_ecs_service" "patient_service" {
  name            = "patient-service"
  cluster         = healthcare-ecs.patient_service.id
  task_definition = aws_ecs_task_definition.patient_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_public_1.id]
    security_groups = [aws_security_group.allow_all.id]
  }
}

resource "aws_ecs_service" "appointment_service" {
  name            = "appointment-service"
  cluster         = healthcare-ecs.appointment_serivce.id
  task_definition = aws_ecs_task_definition.appointment_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_public_1.id]
    security_groups = [aws_security_group.allow_all.id]
  }
}