resource "aws_vpc" "transfer_family_vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "transfer-family-vpc"
  }
}

resource "aws_default_security_group" "transfer_family_sg" {
  vpc_id = aws_vpc.transfer_family_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
}

resource "aws_internet_gateway" "transfer_family_internet_gateway" {
  vpc_id = aws_vpc.transfer_family_vpc.id
  tags = {
    Name = "transfer-family-internet-gateway"
  }
}

resource "aws_route" "transfer_family_route" {
  route_table_id         = aws_vpc.transfer_family_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.transfer_family_internet_gateway.id
}

resource "aws_subnet" "transfer_family_subnet" {
  vpc_id            = aws_vpc.transfer_family_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = local.az
  tags = {
    Name = "transfer-family-subnet"
  }
}

resource "aws_eip" "transfer_family_eip" {
  vpc                  = true
  network_border_group = local.region
}
