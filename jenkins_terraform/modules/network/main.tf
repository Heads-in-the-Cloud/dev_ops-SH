

// VPC for RDS instance
resource "aws_vpc" "vpc-db-sh" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-utopia-SH"
  }
}


// PRIVATE Subnets
resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.vpc-db-sh.id
  cidr_block = var.vpc_subnet_1_private_cidr
  availability_zone = var.zone_1
  tags = {
    Name = "subnet-private-1-SH"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.vpc-db-sh.id
  cidr_block = var.vpc_subnet_2_private_cidr
  availability_zone = var.zone_2
  tags = {
    Name = "subnet-private-2-SH"
  }
}


// PUBLIC Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc-db-sh.id
  cidr_block = var.vpc_subnet_1_public_cidr
  availability_zone = var.zone_1
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-1-SH"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc-db-sh.id
  cidr_block = var.vpc_subnet_2_public_cidr
  availability_zone = var.zone_2
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-2-SH"
  }
}


// Subnet Group (Private)
resource "aws_db_subnet_group" "subnet_group_private" {
  name = "subnet_group_private"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  tags = {
    Name = "utopia-private-subnet-group-SH"
  }
}


// Internet Gateway
resource "aws_internet_gateway" "vpc_gateway" {
  vpc_id = aws_vpc.vpc-db-sh.id
  tags = {
    Name = "utopia-vpc-gateway-SH"
  }
}


// Route Table
resource "aws_route_table" "vpc_routetable" {
  vpc_id = aws_vpc.vpc-db-sh.id
  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.vpc_gateway.id
  }
  tags = { Name = "bastion-host-routetable-SH" }
}

resource "aws_route_table_association" "route-subnet1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.vpc_routetable.id
}

resource "aws_route_table_association" "route-subnet2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.vpc_routetable.id
}
