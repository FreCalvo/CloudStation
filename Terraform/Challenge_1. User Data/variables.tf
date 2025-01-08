variable "aws_region" {
    description = "Region to create EC2 instance"
    default     = "us-east-1" 
}

variable "cidr_block_vpc" {
    description = "VPC cidr_block"
    default     = "10.0.0.0/16"
}

variable "cidr_block_subnet" {
    description = "Subnet cidr_block"
    default     = "10.0.0.0/24"
}

variable "ami_id" {
    description = "AMI ID that will launch the instance"
    default     = "ami-0ebfd941bbafe70c6" 
}

variable "instance_type" {
    description = "Type of EC2 instance"
    default     = "t2.micro"
}

variable "subnet_availability_zone" {
    description = "availability zone where the subnet is going to be placed"
    default     = "us-east-1a"
}

variable "user_data_file" {
    description = "User data file name that will create the Nginx web server"
    default     = "user_data.sh"
}