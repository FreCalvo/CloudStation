output "instance_public_ip" {
    description = "Public IP of the Nginx instance"
    value       = aws_instance.nginx-instance.public_ip
}
