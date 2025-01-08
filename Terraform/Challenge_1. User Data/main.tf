resource "aws_instance" "nginx-instance" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id       = aws_subnet.my_subnet.id
    associate_public_ip_address = true
    
    vpc_security_group_ids = [ aws_security_group.web_sg.id ]
    user_data = file(var.user_data_file) 

    tags = {
        Name = "NginxInstance"
    }

    #Dependencies
    depends_on = [
        aws_subnet.my_subnet,
        aws_security_group.web_sg
    ]
}
