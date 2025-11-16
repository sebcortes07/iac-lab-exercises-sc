# creation of AZ
data "aws_availability_zones" "available" {
  state = "available"
}

# The VPC module handles the VPC, Subnets, IGW, EIP, NAT Gateway,
# Route Tables, and Associations automatically.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = format("%s-vpc", var.prefix)
  cidr = var.vpc_cidr

  # Get availability zones
  azs = data.aws_availability_zones.available.names

  # Define subnet CIDRs dynamically
  # The module automatically detects the subnet type based on the name (public, private, database)
  public_subnets = [
    for i in range(var.number_of_public_subnets) : cidrsubnet(var.vpc_cidr, 3, i)
  ]
  private_subnets = [
    for i in range(var.number_of_private_subnets) : cidrsubnet(var.vpc_cidr, 3, i + var.number_of_public_subnets)
  ]
  intra_subnets = [
    for i in range(var.number_of_secure_subnets) : cidrsubnet(var.vpc_cidr, 3, i + var.number_of_public_subnets + var.number_of_private_subnets)
  ]

  enable_dns_support   = true
  enable_dns_hostnames = true

  # Configure NAT Gateway
  # This creates one NAT Gateway in the first public subnet and routes private traffic to it.
  single_nat_gateway = true

  # Tag the VPC resource itself
  tags = {
    Name = format("%s-vpc", var.prefix)
  }
}