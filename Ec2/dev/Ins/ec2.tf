resource "aws_instance" "web_server" {
        vpc_security_group_ids = [ var.vpc_security_group_ids.id]

    ami = var.ami
    instance_type = var.instance_type
    key_name =  var.tls_private_key
    subnet_id = var.subnet1.id
    associate_public_ip_address = true
    security_groups = var.sg3.id
    private_ip = var.private_ips.id

     provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y nginx",
            "sudo service nginx start"
        ]
        connection {
            type = "ssh"
            user = "ubuntu"
            private_key = file(var.tls_private_key)
            host = aws_instance.web_server.public_ip
        }
       
     }
    tags = {
        Name = "Web Server"
    }
  } 