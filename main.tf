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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "my_igw"
  }
}

###################
# subnet
###################
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sn-a"
  }
}

resource "aws_subnet" "private_subnet1_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "pri-sn1-a"
  }
}

resource "aws_subnet" "private_subnet2_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "pri-sn2-a"
  }
}

resource "aws_subnet" "public_subnet_c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sn-c"
  }
}

resource "aws_subnet" "private_subnet1_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "pri-sn1-c"
  }
}

resource "aws_subnet" "private_subnet2_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "pri-sn2-c"
  }
}

###################
# route tables
###################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-public"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "rt-private"
  }
}


resource "aws_route_table_association" "private1_a" {
  subnet_id      = aws_subnet.private_subnet1_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private2_a" {
  subnet_id      = aws_subnet.private_subnet2_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private1_c" {
  subnet_id      = aws_subnet.private_subnet1_c.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private2_c" {
  subnet_id      = aws_subnet.private_subnet2_c.id
  route_table_id = aws_route_table.private_route_table.id
}

###################
# network ACLs
###################

# ap-northeast-1a Public Subnet
resource "aws_network_acl" "public_subnet_acl_a" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.public_subnet_a.id]

  tags = {
    Name = "acl-public-a"
  }
}

# ap-northeast-1c Public Subnet
resource "aws_network_acl" "public_subnet_acl_c" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.public_subnet_c.id]

  tags = {
    Name = "acl-public-c"
  }
}

# ap-northeast-1a Private Subnet 1
resource "aws_network_acl" "private_subnet1_acl_a" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.private_subnet2_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.private_subnet2_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.private_subnet1_a.id]

  tags = {
    Name = "acl-private1-a"
  }
}

# ap-northeast-1c Private Subnet 1
resource "aws_network_acl" "private_subnet1_acl_c" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.private_subnet2_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.public_subnet_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = aws_subnet.private_subnet2_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.private_subnet1_c.id]

  tags = {
    Name = "acl-private1-c"
  }
}

# ap-northeast-1a Private Subnet 2
resource "aws_network_acl" "private_subnet2_acl_a" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.private_subnet1_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.private_subnet1_a.cidr_block
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.private_subnet2_a.id]

  tags = {
    Name = "acl-private2-a"
  }
}

# ap-northeast-1c Private Subnet 2
resource "aws_network_acl" "private_subnet2_acl_c" {
  vpc_id = aws_vpc.my_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.private_subnet1_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_subnet.private_subnet1_c.cidr_block
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = [aws_subnet.private_subnet2_c.id]

  tags = {
    Name = "acl-private2-c"
  }
}
