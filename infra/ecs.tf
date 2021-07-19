module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.3.0"

  name               = "ledn-${terraform.workspace}"
  capacity_providers = ["FARGATE"]
}