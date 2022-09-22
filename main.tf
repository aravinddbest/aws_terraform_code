resource "aws_vpc" "akvpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "kubctl"
  }
}


resource "aws_subnet" "kubctl-1" {
  vpc_id                  = aws_vpc.akvpc.id
  cidr_block              = var.az_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.availability_az
  tags = {
    Name = "kubctl-1"
  }
}

resource "aws_internet_gateway" "kubctl-igw" {
  vpc_id = aws_vpc.akvpc.id

  tags = {
    Name = "kubctl-ige"
  }

}

resource "aws_route_table" "kubctl-rt" {
  vpc_id = aws_vpc.akvpc.id


  tags = {
    Name = "kubctl-rt"
  }

}

resource "aws_route" "kubctl-route" {
  route_table_id         = aws_route_table.kubctl-rt.id
  destination_cidr_block = var.dert_cidr_block
  gateway_id             = aws_internet_gateway.kubctl-igw.id


}

resource "aws_route_table_association" "rt-association" {
  subnet_id      = aws_subnet.kubctl-1.id
  route_table_id = aws_route_table.kubctl-rt.id

}


resource "aws_security_group" "kubctl-sg" {
  name        = "kubctl-sg"
  description = "kubctl-sg"
  vpc_id      = aws_vpc.akvpc.id

  ingress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "kubctl-allowAll"
  }
}

#resource "aws_key_pair" "kubctlKey" {
 # key_name   = "kubekey"
 # public_key = "kubekey"

#}

resource "aws_instance" "kubnode" {
  instance_type          = var.instance_types
  #count                  = var.ec2_count
  ami                    = data.aws_ami.ubuntu_ami.id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.kubctl-sg.id]
  subnet_id              = aws_subnet.kubctl-1.id
 # user_data              = file("D:/oneDrive/Documents/Terrafrom/userdata.tpl")

  tags = {
    Name = "${var.envi}"
  }
  #tags = {
  #  Name = "${var.envi}-${count.index+1}"
  #}
}

