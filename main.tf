terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
}

# VPC default
data "aws_vpc" "default" {
  default = true
}

# Key pair
resource "aws_key_pair" "deployer_key" {
  key_name   = var.key_name
  public_key = file(var.ssh_public_key)
}

# Security Group
resource "aws_security_group" "vm_sg" {
  name        = "moodle-vm-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "moodle_vm" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
 
  user_data = file("setup_moodle.sh")

  # EBS storage
  root_block_device {
    volume_size = var.disk_size
    volume_type = "gp3" 
    delete_on_termination = true
  }

  tags = {
    Name    = "Moodle LMS"
    Project = "moodle"
  }
}

# Output instance
output "instance_public_ip" {
  value = aws_instance.moodle_vm.public_ip
}

output "instance_public_dns" {
  value = aws_instance.moodle_vm.public_dns
}
