output "vpc_id" {
  value = aws_vpc.vpc_main.id
}

output "subnet_ids_for_cluster" {
  value = {
    primary_subnet_id = aws_subnet.primary_subnet.id
    secondary_subnet_id = aws_subnet.secondary_subnet.id  
  }
}

output "subnet_ids_for_node_group" {
  value = [
    aws_subnet.primary_subnet.id,
    aws_subnet.secondary_subnet.id
  ]
}

output "security_group_id" {
  value = aws_security_group.security_group.id
}