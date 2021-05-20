provider "aws" {
    region = "eu-central-1"
}

terraform {
  backend "s3" {
    key   = "studyenv/global/mgmt/services/ci-server/terraform.tfstate"
  }
}

locals {
  ssh_port = 22 
  any_port = 0 
  any_protocol = "-1" 
  tcp_protocol = "tcp" 
  all_ips = ["0.0.0.0/0"]
  ubuntu_20_04_ami = "ami-0980c5102b5ef10cc" 
}

##########################################################################
#Data source to look up default VPC in AWS
data "aws_vpc" "default" {
  default = true
}

#2nd DS to use in combination with the above to look up subnets in VPC
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

##########################################################################
### Security group configurations

#Security group attached to EC2 instances
resource "aws_security_group" "instance" {
  name = "${var.environment_name}-instance"
}

#Allow SSH to EC2 instance
resource "aws_security_group_rule" "instance_allow_ssh" {
  type                = "ingress"
  security_group_id   = aws_security_group.instance.id

  from_port           = local.ssh_port
  to_port             = local.ssh_port
  protocol            = local.tcp_protocol
  cidr_blocks         = ["${var.myip}/${var.cidr}"]
}

#Allow all outbound traffic
resource "aws_security_group_rule" "instance_allow_all_outbound" {
  type                = "egress" 
  security_group_id   = aws_security_group.instance.id

  from_port           = local.any_port
  to_port             = local.any_port
  protocol            = local.any_protocol
  cidr_blocks         = local.all_ips
}

##########################################################################
### EC2 instance resource configurations 

resource "aws_instance" "ci-server" {
    ami                     = local.ubuntu_20_04_ami
    instance_type           = "t2.micro"
    vpc_security_group_ids  = [aws_security_group.instance.id]

  # the public SSH key
    key_name                = aws_key_pair.ciserver.key_name

    tags = {
    Name = "ci-server"
  }
}