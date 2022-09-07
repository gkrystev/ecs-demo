
resource "aws_ecs_cluster" "demo_cluster" {
  name = "Demo_CSR_Cluster"
}

resource "aws_ecs_task_definition" "db_init" {
  family                   = "db_init"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = templatefile(
    "../task-definitions/db_init.json",
    {
      rds_host             = aws_db_instance.ecs_demo.address
      rds_port             = aws_db_instance.ecs_demo.port
      rds_root_username    = aws_db_instance.ecs_demo.username
      rds_root_password    = aws_secretsmanager_secret.rds_root_password.arn
      web_app_db_username  = var.web_app_db_username
      web_app_db_name      = var.web_app_db_name
      region               = data.aws_region.current.name
      account_id           = data.aws_caller_identity.current.account_id
      db_init_image        = var.db_init_image
      ecs_log_group        = var.ecs_log_group
      ecs_log_prefix       = var.ecs_log_prefix
    }
  )
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = aws_iam_role.ecs_demo_execution_role_db_init.arn
}

resource "aws_ecs_task_definition" "web_service" {
  family                   = "web_service"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  container_definitions    = templatefile(
    "../task-definitions/web_service.json",
    {
      rds_host            = aws_db_instance.ecs_demo.address
      rds_port            = aws_db_instance.ecs_demo.port
      region              = data.aws_region.current.name
      account_id          = data.aws_caller_identity.current.account_id
      web_app_image       = var.web_app_image
      web_app_db_username = var.web_app_db_username
      web_app_db_name     = var.web_app_db_name
      ecs_log_group       = var.ecs_log_group
      ecs_log_prefix      = var.ecs_log_prefix
    }
  )
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  task_role_arn      = aws_iam_role.ecs_demo_task_role_web_service.arn
  execution_role_arn = aws_iam_role.ecs_demo_execution_role_web_service.arn
}

resource "aws_ecs_service" "web_service" {
  name            = "web_service"
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.web_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = [aws_security_group.ecs_web_service.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "db_init" {
  name            = "db_init"
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.db_init.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ecs_web_service.id]
    assign_public_ip = false
  }
}
