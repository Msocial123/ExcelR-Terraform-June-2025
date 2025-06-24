provider "aws" {
  region = "ap-south-1"
}

#Create a VPC 
resource "aws_vpc" "example-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "clahan-murali"
  }
}
#Create a Subnet 
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.example-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "clahan-public-subnet"
  }
}
# Create a Private Subnet 
resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.example-vpc.id
  availability_zone = "ap-south-1b"
  tags = {
    Name = "clahan-private-subnet"
  }
}
# Create a Internet Gateway 
resource "aws_internet_gateway" "clahan-igw" {
  vpc_id = aws_vpc.example-vpc.id
  tags = {
    Name = "Clahan-Internet-Example"
  }
}

# Create Routable for the Public Subnet 
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.example-vpc.id
  tags = {
    Name = "Public-rt"
  }
}

# Create a Route Table attach Internet gateway 
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.clahan-igw.id
}
# Create a Private table 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.example-vpc.id
  tags = {
    Name = "private-rt"
  }
}

# Associate Route Table with Public Subnet 
resource "aws_route_table_association" "pyblic_rta" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Instance in Public Subnet 
resource "aws_instance" "public_Instance" {
  ami = "ami-0b09627181c8d5778"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  key_name = "Test-VPC"
  tags = {
    Name = "Clahan-Public-Instance"
  }
}

# Create a Security Group 
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow inbound Traffic"
  vpc_id      = aws_vpc.example-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-sg"
  }
}

# Create a Elastic IP for NAT 
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

#Create a NAT Gateway
resource "aws_nat_gateway" "example_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "example-nat"
  }
}

# Create a Route in a Private Subnet 
resource "aws_route_table" "private_rt_example" {
  vpc_id = aws_vpc.example-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example_nat.id
  }

  tags = {
    Name = "Private-rt-example"
  }
}


# Associate routable with private subnet 
resource "aws_route_table_association" "private_rta" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt_example.id
}