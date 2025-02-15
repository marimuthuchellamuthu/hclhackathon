resource "aws_ecs_cluster" "example_cluster" {
  name = "example-cluster"
}


resource "aws_ecs_task_definition" "patient_service_task" {
  family                   = "patient-service-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "patient-service"
    image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:patient-app"
    portMappings = [
      {
        containerPort = 3000
        hostPort      = 3000
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "appointment_service_task" {
  family                   = "appointment-service-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "appointment-service"
    image     = "539935451710.dkr.ecr.us-east-1.amazonaws.com/hcl-hackathon/healthcare:patient-app"
    portMappings = [
      {
        containerPort = 3001
        hostPort      = 3001
      }
    ]
  }])
}