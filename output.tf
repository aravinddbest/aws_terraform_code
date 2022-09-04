

output "instance_name" {
    value = var.envi[*]
  
}

output "instance_public_IP" {
   value = aws_instance.kubnode.public_ip
}

#output "instance_private_ip" {
#    value = var.aws_network_interface.pubip.id
#  
#}