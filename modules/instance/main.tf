data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "main" {
  count = var.public_key != "" ? 1 : 0

  key_name   = "${var.environment}-web-key"
  public_key = var.public_key

  tags = {
    Name        = "${var.environment}-web-key"
    Environment = var.environment
  }
}

resource "aws_instance" "main_instance" {
  ami           = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.public_key != "" ? aws_key_pair.main[0].key_name : null

  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }

  user_data = <<-EOF
  #!/bin/bash
  set -euxo pipefail

  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y nginx

  cat > /var/www/html/index.html <<'HTML'
  <!DOCTYPE html>
  <html>
    <head>
      <title>Daniel Benjamin</title>
    </head>
    <body>
      <h1>Daniel Benjamin</h1>
      <h2>HUG Lagos/Ibadan Terraform Challenge</h2>
    </body>
  </html>
  HTML

  systemctl enable --now nginx
  EOF
}
