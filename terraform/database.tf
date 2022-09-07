
resource "aws_db_parameter_group" "ecs_demo" {
  family      = "mariadb10.6"
  name        = "ecs-demo"
  description = "ecs-demo"
}

resource "aws_db_option_group" "ecs_demo" {
  name                     = "ecs-demo"
  option_group_description = "ecs-demo"
  engine_name              = "mariadb"
  major_engine_version     = "10.6"
}

resource "aws_db_subnet_group" "ecs_demo" {
  name        = "ecs-demo"
  description = "ecs-demo"
  subnet_ids  = module.vpc.private_subnets
}

resource "random_password" "rds_root_password" {
  length           = 40
  override_special = "!#$%&*-_=+:?"
}

resource "aws_secretsmanager_secret" "rds_root_password" {
  name = "ecs-demo/rds-root-password"
}

resource "aws_secretsmanager_secret_version" "rds_root_password" {
  secret_id     = aws_secretsmanager_secret.rds_root_password.id
  secret_string = random_password.rds_root_password.result
}

resource "aws_db_instance" "ecs_demo" {
  identifier             = "ecs-demo"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  engine                 = "mariadb"
  engine_version         = "10.6"
  parameter_group_name   = aws_db_parameter_group.ecs_demo.id
  option_group_name      = aws_db_option_group.ecs_demo.id
  db_subnet_group_name   = aws_db_subnet_group.ecs_demo.id
  vpc_security_group_ids = [aws_security_group.rds_mysql.id]
  username               = "root"
  password               = aws_secretsmanager_secret_version.rds_root_password.secret_string
  apply_immediately      = true

  iam_database_authentication_enabled = true
}
