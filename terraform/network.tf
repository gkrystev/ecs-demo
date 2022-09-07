
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  name    = "ECS-Demo"
  cidr    = var.vpc_cidr
  azs     = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_ipv6          = true
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_security_group" "ecs_web_service" {
  vpc_id = module.vpc.vpc_id
  name = "ECS_Web_Service"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "ecs_web_public_http_access" {
  description = "Public HTTP access"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_web_service.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "ecs_web_public_https_access" {
  description = "Public HTTP access"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ecs_web_service.id
  cidr_blocks       = ["0.0.0.0/0"]
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group" "rds_mysql" {
  vpc_id = module.vpc.vpc_id
  name = "RDS_MySQL"
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "ecs_rds_access" {
  description              = "RDS access"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_mysql.id
  source_security_group_id = aws_security_group.ecs_web_service.id
  to_port                  = 3306
  type                     = "ingress"
}
