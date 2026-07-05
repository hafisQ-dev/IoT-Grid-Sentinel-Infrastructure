# =====================================================================
# TERRAFORM CONFIGURATION FOR TRANSFORMER ANALYZING CENTER
# =====================================================================

# 1. Terraform Core Settings
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# 2. Region Configuration
provider "aws" {
  region = "eu-central-1" # Frankfurt region
}

# =====================================================================
# SECURITY & ACCESS CONTROL
# =====================================================================

# SSH Key Pair for secure instance access
resource "aws_key_pair" "server_key" {
  key_name   = "trafo-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# Firewall Rules (Security Group)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_trafo"
  description = "Open required ports for IoT Infrastructure and Management"

  tags = {
    Name = "allow_ssh"
  }

  # 1. SSH Access (Required for Ansible Management)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 2. MQTT Broker Port (For receiving transformer data)
  ingress {
    from_port   = 1883
    to_port     = 1883
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 3. InfluxDB API & UI Port
  ingress {
    from_port   = 8086
    to_port     = 8086
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # 4. Grafana Web Dashboard Port (For monitoring charts)
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules: Allows server to pull Docker images from Docker Hub
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols allowed
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# =====================================================================
# COMPUTE INSTANCE (EC2)
# =====================================================================

# AWS EC2 Virtual Server Provisioning
resource "aws_instance" "example" {
  ami           = "ami-0084a47cc718c111a" # Ubuntu Server AMI
  instance_type = "t3.micro"

  key_name               = aws_key_pair.server_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Transformator Analyzing Center"
  }
}
