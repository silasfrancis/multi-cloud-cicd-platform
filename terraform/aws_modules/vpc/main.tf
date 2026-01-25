terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

resource "aws_vpc" "vpc_main" {
  region = var.region
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_subnet" "primary_subnet" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.1.0/24"
  region = var.region
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.vpc_tag}-subnet1"
  }
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id = aws_vpc.vpc_main.id
  cidr_block = "10.0.1.0/24"
  region = var.region
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.vpc_tag}-subnet2"
  }
}

resource "aws_security_group" "security_group" {
    name = "allow traffic"
    description = "allow traffic on port 80 and 443"
    vpc_id = aws_vpc.vpc_main.id
  
}

resource "aws_security_group_rule" "ingress_rule_internal" {
    type = "ingress"
    description = "Allow HTTP traffic from anywhere"
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    security_group_id = aws_security_group.security_group.id

}

resource "aws_security_group_rule" "ingress_rule_http" {
    type = "ingress"
    description = "Allow HTTP traffic from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.security_group.id

}

resource "aws_security_group_rule" "ingress_rule_https" {
    type = "ingress"
    description = "Allow HTTPS traffic from anywhere"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.security_group.id

}
resource "aws_security_group_rule" "ingress_rule_https" {
    type = "egress"
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.security_group.id

}