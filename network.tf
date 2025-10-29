# creation of the vpc
resource "aws_vpc" "vpc" {
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

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-%s", var.prefix, count.index + 1)
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private_subnets" {
  count = var.number_of_private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-private-subnet-%s", var.prefix, count.index + 1)
  }
}

# SECURE SUBNETS
resource "aws_subnet" "secure_subnets" {
  count = var.number_of_secure_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 4)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = format("%s-secure-subnet-%s", var.prefix, count.index + 1)
  }
}

# ADDING INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format("%s-igw", var.prefix)
  }
}

# ADDING AN ELASTIC IP FOR NAT GATEWAY
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = format("%s-nat-eip", var.prefix)
  }
}

# ADDING A NAT GATEWAY
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnets[1].id

  tags = {
    Name = format("%s-nat-gateway", var.prefix)
  }
}

# ADDING A PUBLIC ROUTE TABLE
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-public_route_table", var.prefix)
  }
}

# ADDING A PRIVATE ROUTE TABLE
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = format("%s-private_route_table", var.prefix)
  }
}

# ADDING A PUBLIC SUBNET ASSOCIATIONS - example using for_each
resource "aws_route_table_association" "public_subnets_assoc" {
  for_each = { for name, subnet in aws_subnet.public_subnets : name => subnet }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}

# ADDING A PRIVATE SUBNET ASSOCIATIONS - example using count
resource "aws_route_table_association" "private_subnets_assoc" {
  count = var.number_of_private_subnets

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}