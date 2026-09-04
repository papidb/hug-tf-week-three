resource "aws_internet_gateway" "main_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_route_table" "main_vpc_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet_route_table" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main_vpc_route_table.id
}
