output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "default_sg_id" {
  value = aws_security_group.default.id
}

output "public_subnets_id" {
  value = toset([
    for subnet in aws_subnet.public_subnet : subnet.id
  ])
}

output "private_subnets_id" {
  value = toset([
    for subnet in aws_subnet.private_subnet : subnet.id
  ])
}

output "subnets_id" {
  value = concat(tolist([
    for subnet in aws_subnet.private_subnet : subnet.id
    ]),
    tolist([
      for subnet in aws_subnet.public_subnet : subnet.id
    ]),
  )

  depends_on = [aws_route_table_association.private, aws_route_table_association.public]

}

