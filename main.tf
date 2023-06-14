terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.1.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

###################
# vpc
###################
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/21"
  tags = {
    Name  = "cloudtech2-1"
    Issue = "2-1"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "sn-pub-a"
  }
}

resource "aws_subnet" "private_subnet1_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private_subnet2_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "sn-pub-c"
  }
}

resource "aws_subnet" "private_subnet1_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "private_subnet2_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-1c"
}
