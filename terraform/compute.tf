
# Create an ssh key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create a key pair
resource "aws_key_pair" "instance_key" {
  key_name = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}


# Create an instance

resource "aws_instance" "app_instance" {
  ami= "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name = aws_key_pair.instance_key.id
  user_data = file("./install-docker.sh")
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  tags = {
    Name = "app_server"
  }
}

# Assiciate the elastic ip

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.app_instance.id
  allocation_id = "eipalloc-0bf37d8bc49556885"
}


# Create the security group

resource "aws_security_group" "app_sg" {
  name        = "public_instances_sg"
  description = "Security group for public instances"
  
}

resource "aws_security_group_rule" "ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "engress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app_sg.id
}
 
