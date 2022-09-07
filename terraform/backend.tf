terraform {
  backend "s3" {
    bucket         = "ecs-demo-terraform-state-bucket"
    key            = "terraform"
    region         = "us-east-1"
    encrypt        = true
  }
}
