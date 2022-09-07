variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIRD for ECS cluster."
}

variable "vpc_private_subnets" {
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "List for private subnet CIDRs"
  type        = list(string)
}

variable "vpc_public_subnets" {
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "ecs_log_group" {
  default     = "/ecs-demo"
  description = "Log group in CloudWatch Logs"
}

variable "ecs_log_prefix" {
  default     = "demo"
  description = "Log group prefix in CloudWatch Logs"
}

variable "web_app_image" {
  default     = "web_app_php:latest"
  description = "Image to use for web_app"
}

variable "db_init_image" {
  default     = "db_init:latest"
  description = "Image to use for db_init"
}

variable "web_app_db_username" {
  default     = "web_app"
  description = "Username to be used for accessing RDS"
}

variable "web_app_db_name" {
  default     = "web_app"
  description = "RDS database name"
}
