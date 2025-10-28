# creation of the vpc
resource "aws_vpc" "iac_lab_vpc" {
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
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.iac_lab_vpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.iac_lab_vpc.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-public-subnet-2", var.prefix)
  }
}

# PRIVATE SUBNETS
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet3_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = format("%s-private-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = format("%s-private-subnet-2", var.prefix)
  }
}

# SECURE SUBNETS
resource "aws_subnet" "secure_subnet_1" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet5_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = format("%s-secure-subnet-1", var.prefix)
  }
}

resource "aws_subnet" "secure_subnet_2" {
  vpc_id            = aws_vpc.iac_lab_vpc.id
  cidr_block        = var.subnet6_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = format("%s-secure-subnet-2", var.prefix)
  }
}

# IMPORTED SUBNET
# resource "aws_subnet" "subnet_7_moved" {
#   # Write all configuration arguments here (e.g., vpc_id, cidr_block, availability_zone).
#   # These arguments MUST match the existing subnet's properties.
#   vpc_id                  = aws_vpc.iac_lab_vpc.id
#   cidr_block              = "192.168.1.96/28"
#   availability_zone       = "eu-central-1a"
#
#   tags = {
#     Name = "subnet_7"
#   }
# }

# import {
#   # The resource defined above
#   to = aws_subnet.subnet_7
#   # The actual ID of the live subnet in your AWS account
#   id = "subnet-05780f524174e204e"
# }

# moved {
#   from = aws_subnet.subnet_7
#   to   = aws_subnet.subnet_7_moved
# }

# ADDING INTERNET GATEWAY
resource "aws_internet_gateway" "iac_lab_igw" {
  vpc_id = aws_vpc.iac_lab_vpc.id

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
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = format("%s-nat-gateway", var.prefix)
  }
}

# ADDING A PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.iac_lab_vpc.id

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
  vpc_id = aws_vpc.iac_lab_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.iac_lab_nat_gw.id
  }

  tags = {
    Name = format("%s-private-rt", var.prefix)
  }
}

# ADDING A PUBLIC SUBNET ASSOCIATIONS
resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# ADDING A PRIVATE SUBNET ASSOCIATIONS
resource "aws_route_table_association" "private_subnet_1_assoc" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_subnet_2_assoc" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt.id
}