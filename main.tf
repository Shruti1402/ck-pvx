# VPC
resource "aws_vpc" "peoplevox_vpc" {
  cidr_block = var.peoplevox_vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ck-pvx-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "peoplevox_public_subnet" {
  count = 1
  vpc_id     = aws_vpc.peoplevox_vpc.id
  cidr_block = var.peoplevox_public_subnet_cidr[count.index]
  availability_zone = "us-east-1a"

  tags = {
    Name = "ck-pvx-publicsubnet${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "peoplevox_private_subnet" {
  count = 2
  vpc_id     = aws_vpc.peoplevox_vpc.id
  cidr_block = var.peoplevox_private_subnet_cidr[count.index]
  availability_zone = element(["us-east-1b", "us-east-1c"], count.index)

  tags = {
    Name = "ck-pvx-privatesubnet${count.index + 1}"
  }
}

# SQS Queue
resource "aws_sqs_queue" "peoplevox_sqs_queue" {
  name = "ck-pvx-sqs"
}

#Craete sg for RDS
resource "aws_security_group" "peoplevox_db_instance" {
  description = "security-group-db-instance"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3360
    protocol    = "tcp"
    to_port     = 3360
  }

  name = "ck-pvx-sg-dbinstance"

  tags = {
    Name = "ck-pvx-sg-dbinstance"
  }
  vpc_id = aws_vpc.peoplevox_vpc.id
}

resource "aws_db_subnet_group" "peoplevox_sg" {
  name = var.peoplevox_db_subnet_group_name

  subnet_ids = [
    aws_subnet.peoplevox_private_subnet[0].id,
    aws_subnet.peoplevox_private_subnet[1].id
  ]

  tags = {
    Name = "ck-pvx-db-subnet-group"
  }
}

#Create RDS
resource "aws_db_instance" "peoplevox_rds" {
  db_subnet_group_name = var.peoplevox_db_subnet_group_name
  allocated_storage    = var.peoplevox_db_allocated_storage
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.peoplevox_db_instance_type
  identifier           = var.peoplevox_db_identifier
  username             = var.peoplevox_db_username
  password             = var.peoplevox_db_password
  parameter_group_name = "default.mysql5.7"
  multi_az             = true
}