packer {
    # aws
  required_plugins {
    amazon =  {
      version = "1.1.6"
      source =  "github.com/hashicorp/amazon"
      
    }
    
  }


}

locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")

}

source "amazon-ebs" "labRDSexample" {

ami_name = "labRDSimage-${local.timestamp}"
source_ami = "ami-052efd3df9dad4825" 
instance_type = "t2.micro"
region = "us-east-1"
ssh_username = "ubuntu" 
access_key = "AKIAW5U7OXJC2FIMGJXJ"
secret_key = "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"

}

build {

  sources = [
    "source.amazon-ebs.labRDSexample"

  ]

  provisioner "file" {
    source = "/Users/chrismello/git_repo/RDS-php-lab.zip"
    destination = "/home/ubuntu/RDS-php-lab.zip" 
  }

  provisioner "shell" {
    script = "./installpackages.bash"
  }


}



