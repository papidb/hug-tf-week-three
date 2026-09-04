
resource "aws_security_group" "allow_default_ssh_and_http_ports_security_group" {
  name        = "Allow ssh and http"
  description = "Allow ssh on port 22 and http on port 80"

  vpc_id = var.vpc_id

  tags = {
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_on_port_22" {
  security_group_id = aws_security_group.allow_default_ssh_and_http_ports_security_group.id

  cidr_ipv4 = var.ssh_cidr

  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_on_port_80" {
  security_group_id = aws_security_group.allow_default_ssh_and_http_ports_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.allow_default_ssh_and_http_ports_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
