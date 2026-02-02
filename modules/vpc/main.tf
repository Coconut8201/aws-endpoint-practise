# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

# Subnet
resource "aws_subnet" "sbt" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.az

  tags = {
    Name = "${var.vpc_name}-subnet"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-rtb"
  }
}

# Associate Private Subnets with Route Table
resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.sbt.id
  route_table_id = aws_route_table.rtb.id
}

# VPC Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.rtb.id]

  tags = {
    Name = "${var.vpc_name}-s3-endpoint"
  }
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "${var.vpc_name}-sg"
  description = "Security Group for ${var.vpc_name}"
  vpc_id      = aws_vpc.this.id

  # Allow SSH from VPN client
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-default-sg"
  }
}
