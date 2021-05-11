terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.37"
    }
  }
  required_version = "0.15.1"
}

provider "aws" {
  profile = "default"
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
# Creating key pair
resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cdr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
    Location = var.vpc_location
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "myrouttable" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.rout_cdr
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = var.rout_name
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet_cidr
  availability_zone=var.availability_zone
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_route_table_association" "routassociation" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myrouttable.id
}
resource "aws_instance" "myec2" {
  ami           = var.ami
  instance_type = var.instance_type
  count = var.ec2_count 
  availability_zone = var.availability_zone
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  subnet_id              = aws_subnet.mysubnet.id
  tags = {
    #Name = "${var.servername}-${random_id.myrandomid.id}"
#Name = "${var.servername}-${random_id.myrandomid.dec}"    
Name = "${var.servername}-${count.index}"
#Name = var.servername    
    Environment = "dev"
  }
}
resource "aws_security_group" "my_security_group" {
        name = "my_security_group"
	vpc_id      = aws_vpc.myvpc.id        
	ingress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }

          egress {
            from_port       = 0
            to_port         = 0
            protocol        = "-1"
            cidr_blocks     = ["0.0.0.0/0"]
        }
        tags = {
                Name = "Allow All"
		Environment = "dev"
        }

}
resource "random_id" "myrandomid" {
  byte_length = 3
}
