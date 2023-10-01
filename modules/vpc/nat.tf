/* 6.1) Elastic IP for each NAT gateway */
resource "aws_eip" "nat_eip" {
  for_each   = var.nat_enabled ? var.public_subnets : {}
  
  domain     = "vpc"
  depends_on = [aws_internet_gateway.ig]
  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-nat-eip-${each.key}"
    },
  )
}

/* 6.2) Create NAT gateway in each public Subnet -
        It is use to give internet access to private subnet resources
 */
resource "aws_nat_gateway" "nat" {
  for_each   = var.nat_enabled ? var.public_subnets : {}
 
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id
  depends_on    = [aws_subnet.public_subnet, aws_eip.nat_eip]

  tags = merge(
    var.additional_tags,
    {
      Name = "${var.environment}-nat-${each.key}"
    },
  )
}


/* 5.4) To give Internet access to resources in private subnet 
        Add below route in private route table
*/

resource "aws_route" "private_nat_gateway" {
  
  for_each   = var.nat_enabled ? var.private_subnets : {}
  
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
  depends_on = [
    aws_route_table.private, aws_nat_gateway.nat, aws_subnet.private_subnet
  ]
}