resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Environment = var.environment
  }
}
