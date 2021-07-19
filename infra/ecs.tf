module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.3.0"

  name               = "ledn"
  capacity_providers = ["FARGATE"]
}