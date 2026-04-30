provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical ->Only choose Ubuntu images published by Canonical’s official AWS account.

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "tls_private_key" "carzone_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "carzone_key" {
  key_name   = "carzone-key-pair"
  public_key = tls_private_key.carzone_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content         = tls_private_key.carzone_key.private_key_pem
  filename        = "${path.module}/carzone-key-pair.pem"
  file_permission = "0400"
}
resource "aws_iam_role" "ec2_ecr_role" {
  name = "carzone-ec2-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "carzone-ec2-instance-profile"
  role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_security_group" "carzone_sg" {
  name        = "carzone-security-group"
  description = "Allow SSH and HTTP traffic"

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "HTTP public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS public access future use"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "carzone_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.carzone_key.key_name
  vpc_security_group_ids = [aws_security_group.carzone_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/user_data.sh", {
    aws_region     = var.aws_region
    aws_account_id = var.aws_account_id
    ecr_repo_name  = var.ecr_repo_name
    secret_key     = var.secret_key
    db_password    = var.db_password
  })

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "carzone-devops-ec2"
  }
}