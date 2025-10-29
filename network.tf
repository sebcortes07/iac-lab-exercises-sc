# creation of the vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}

# creation of AZ
data "aws_availability_zones" "available" {
  state = "available"
}

# creation of subnets
# PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
  count = var.number_of_public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("${var.prefix}-public-subnet-%s", count.index + 1)
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private_subnets" {
  count = var.number_of_private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${var.prefix}-private-subnet-%s", count.index + 1)
  }
}

# SECURE SUBNETS
resource "aws_subnet" "secure_subnets" {
  count = var.number_of_secure_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("${var.prefix}-secure-subnet-%s", count.index + 1)
  }
}

# ADDING INTERNET GATEWAY
resource "aws_internet_gateway" "iac_lab_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = format("%s-igw", var.prefix)
  }
}

# ADDING AN ELASTIC IP FOR NAT GATEWAY
resource "aws_eip" "iac_lab_nat_eip" {
  domain = "vpc"

  tags = {
    Name = format("%s-nat-eip", var.prefix)
  }
}

# ADDING A NAT GATEWAY
resource "aws_nat_gateway" "iac_lab_nat_gw" {
  allocation_id = aws_eip.iac_lab_nat_eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = format("%s-nat-gateway", var.prefix)
  }
}

# ADDING A PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iac_lab_igw.id
  }

  tags = {
    Name = format("%s-public-rt", var.prefix)
  }
}

# ADDING A PRIVATE ROUTE TABLE
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.iac_lab_nat_gw.id
  }

  tags = {
    Name = format("%s-private-rt", var.prefix)
  }
}

# ADDING A PUBLIC SUBNET ASSOCIATIONS
resource "aws_route_table_association" "public_subnets_assoc" {
  count = var.number_of_public_subnets

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ADDING A PRIVATE SUBNET ASSOCIATIONS
resource "aws_route_table_association" "private_subnets_assoc" {
  count = var.number_of_private_subnets

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}