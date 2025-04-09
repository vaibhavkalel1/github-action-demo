provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-06b6e5225d1db5f46"  # Replace with latest Amazon Linux AMI for your region
  instance_type = "t2.micro"

  tags = {
    Name = "GitHubActions-EC2"
  }
}
