# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

#create a subnet 1/3
resource "aws_subnet" "subnet-1" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.0.0/20"
    availability_zone       = "us-east-2a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-2" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.16.0/20"
    availability_zone       = "us-east-2b"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-3" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.32.0/20"
    availability_zone       = "us-east-2c"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw-1" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt-1" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-1.id
    }
    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "local"
    }      
}

#Associate Route Table to Subnets
resource "aws_route_table_association" "subnet-1-ass" {
    subnet_id = aws.subnet.subnet-1.id
    route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "subnet-2-ass" {
    subnet_id = aws.subnet.subnet-2.id
    route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "subnet-3-ass" {
    subnet_id = aws.subnet.subnet-3.id
    route_table_id = aws_route_table.route_table.id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "eks-cluster"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = aws_vpc.main.id
  subnet_ids               = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id, aws_subnet.subnet-3.id]
  control_plane_subnet_ids = [aws_subnet.subnet-1.id, aws_subnet.subnet-2.id, aws_subnet.subnet-3.id]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.small"]
    }
  }
}
