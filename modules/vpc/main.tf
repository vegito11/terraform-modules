/* This tags are needs for eks loadbalancer */
locals {
  eks_public_subnet_tags  = var.eks_cluster_name != "" ? { "kubernetes.io/cluster/${var.eks_cluster_name}" : "shared", "kubernetes.io/role/elb" : "1" } : {} 
  eks_private_subnet_tags = var.eks_cluster_name != "" ? { "kubernetes.io/cluster/${var.eks_cluster_name}" : "shared", "kubernetes.io/role/internal-elb" : "1" } : {}
}


/* 1) Create VPC  */

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-vpc"
    },
  )
}

/* 2) VPC's Default Security Group */
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }


  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-default-sg"
    },
  )
}




/* 3) Create Internet gateway and attach to our VPC */
resource "aws_internet_gateway" "ig" {
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_vpc.vpc]

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-igw"
    },
  )
}

/* 4) Public Subnets */

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.public_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(
    var.additional_tags,
    local.eks_public_subnet_tags,
    {
      Name = "${var.environment}-public-subnet-${each.key}"
    },
  )

  depends_on = [aws_vpc.vpc]
}

/* 4.2) Create Routing table for public subnets - Only 1 table for all public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-public-route-table"
    },
  )
}

/* 4.3) Create Route and attach it to public route table.
  Adding below rules actually make public subnet public.
*/
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

/* 4.4) Route table associations */
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public_subnet, aws_route_table.public]
}


/* 5.1) Private subnet */

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  for_each                = var.private_subnets
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge(
    var.additional_tags,
    local.eks_private_subnet_tags,
    {
      Name = "${var.environment}-private-subnet-${each.key}"
    },
  )
  depends_on = [aws_vpc.vpc]
}


/* 5.2) Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id   = aws_vpc.vpc.id
  for_each = var.private_subnets
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-private-route-table"
    },
  )
}


/* 5.3) associatie Private route table to private subnet */

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private[each.key].id
  depends_on     = [aws_subnet.private_subnet, aws_route_table.private]
}


