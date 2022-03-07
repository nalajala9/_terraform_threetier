terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
   access_key = ""
   secret_key = ""  
   region = "us-east-1"
}

resource "aws_instance" "web" {
    count= "3"
    ami = "${var.ami}"
    instance_type = "t2.micro"
    subnet_id = "${element(aws_subnet.publicsubnets.*.id,count.index)}"
    vpc_security_group_ids = ["${aws_security_group.sg.id}"]
    tags = {
        Name = "Webserver_${count.index+1}"
        }
}

resource "aws_security_group" "sg" {
  name        = "SG"
  description = "Enable SSH access via port 22"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
      Name = "SG_${var.vpcname}"
  }
}