provider "aws" {
  region = "ap-south-1"
}

# Create VPC
resource "aws_vpc" "testvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "TestVPC"
  }  
}

# Create Subnet
resource "aws_subnet" "testsubnet" {
  vpc_id            = aws_vpc.testvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "TestSubnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "testigw" {
  vpc_id = aws_vpc.testvpc.id

  tags = {
    Name = "TestIGW"
  }
}

# Create Route Table
resource "aws_route_table" "testrt" {
  vpc_id = aws_vpc.testvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.testigw.id
  }

  tags = {
    Name = "TestRouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "testassoc" {
  subnet_id      = aws_subnet.testsubnet.id
  route_table_id = aws_route_table.testrt.id
}

# Create Security Group
resource "aws_security_group" "testsg" {
  name        = "test_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.testvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0 
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TestSecurityGroup"
  }
}

# Launch EC2 Instance
resource "aws_instance" "testec2" {
  ami                         = "ami-06b6e5225d1db5f46"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.testsubnet.id
  vpc_security_group_ids      = [aws_security_group.testsg.id]
  associate_public_ip_address = true

  tags = {
    Name = "GitHubActions-EC2"
  }
}
