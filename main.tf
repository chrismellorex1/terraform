terraform {
  backend "remote" {
    organization = "example-org-7635c8"

    workspaces {
      name = "CreateRDSlab"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 3.59.0"
    }
  }

}

provider "aws" {
  region = "us-east-1"
#  shared_credentials_file = "/Users/chrismello/.aws/credentials"

}


data "aws_vpc" "main" {
   id ="vpc-009e22e02a9d31224"

}





resource "aws_security_group" "sg_lab_RDS" {
  name        = "sg_lab_RDS"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-009e22e02a9d31224"

  ingress = [ 
    {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    },
    {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    security_groups = []
    self = false
    }
  ]  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg_lab_RDS"
  }
}



module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "RDS-lab-terraform"

  ami                    = "ami-05e4c905d9446a664"
  instance_type          = "t2.micro"
  key_name               = "jenkins-external"
  monitoring             = true
  vpc_security_group_ids = ["sg_lab_RDS"]
  // subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}







