##############################################################################
#                       NETWORKING                                           #
##############################################################################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${var.name}-vpc"

  cidr = "10.1.0.0/16"

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = false
}

resource "aws_security_group" "task_def_sg" {
  name        = "${var.name}-security-group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##############################################################################
#                       ECS RESOURCES                                        #
##############################################################################
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "${var.name}-log-group"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "task_def" {
  family = "${var.name}-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::498352900801:role/ecsTaskExecutionRole"

  cpu       = 256
  memory    = 512

  container_definitions = <<EOF
[
  {
    "name": "curso_devops",
    "image": "gabalconi/curso_devops:latest",
    "cpu": 0,
    "memory": 128,
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "eu-west-2",
        "awslogs-group": "${var.name}-log-group",
        "awslogs-stream-prefix": "curso_devops"
      }
    },
    "portMappings": [
        {
            "containerPort": 8080,
            "hostPort": 8080,
            "protocol": "tcp"
        }
    ]
  }
]
EOF
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.task_def_sg.id]
    subnets          = module.vpc.public_subnets
  }

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-cluster"

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

