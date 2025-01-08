
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block_vpc
    tags = {
        Name = "MyVPC"
    }
}

resource "aws_subnet" "my_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = var.cidr_block_subnet
    availability_zone = var.subnet_availability_zone
    map_public_ip_on_launch  = true  
    tags = {
        Name = "MySubnet"
    }
}

resource "aws_security_group" "web_sg" {
    name        = "web_sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "WebSecurityGroup"
    }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "MyInternetGateway"
    }
}

# Create a Route Table for public traffic
resource "aws_route_table" "my_route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name = "MyRouteTable"
    }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "my_route_table_assoc" {
    subnet_id      = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.my_route_table.id
}