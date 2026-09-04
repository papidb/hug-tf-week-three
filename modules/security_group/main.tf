resource "aws_security_group" "compute" {
  name        = "${var.environment}-compute-sg"
  description = "Allow SSH from admin IP and HTTP from the internet"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-compute-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_on_port_22" {
  security_group_id = aws_security_group.compute.id
  description       = "SSH from admin IP only"

  cidr_ipv4   = var.ssh_cidr
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_on_port_80" {
  security_group_id = aws_security_group.compute.id
  description       = "HTTP from the internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "compute_allow_all_outbound" {
  security_group_id = aws_security_group.compute.id
  description       = "Allow all outbound"

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "database" {
  name        = "${var.environment}-database-sg"
  description = "Allow database access from the compute security group only"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-database-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_db_from_compute" {
  security_group_id = aws_security_group.database.id
  description       = "Database port from compute security group only"

  referenced_security_group_id = aws_security_group.compute.id
  from_port                    = var.db_port
  ip_protocol                  = "tcp"
  to_port                      = var.db_port
}
