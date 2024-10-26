terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region
  profile = "raghava"
}
resource "aws_vpc" "VP_1" {
  cidr_block       = var.vpc_cidr
enable_dns_hostnames = true
  tags = {
    Name = "vp_1"
  }
}
resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.VP_1.id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet1"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.VP_1.id
  tags = {
    Name = "internetgw"
  }
}
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.VP_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "routetable"
  }
}
resource "aws_route_table_association" "routr" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_security_group" "sg3" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VP_1.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }
  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "sg3"
  }
}
resource "aws_network_interface" "nic" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["172.16.10.100"]
  security_groups = [aws_security_group.allow_tls.id]
}
resource "tls_private_key" "fullkey" {
   algorithm = "RSA"
   rsa_bits  = 4096  
}
resource "aws_key_pair" "generated_key" {
  key_name   = "fullkey"
  public_key = tls_private_key.fullkey.public_key_openssh
}
resource "local_file" "pem" {
    content     = tls_private_key.fullkey.private_key_pem
    filename = "fullkey.pem"
}