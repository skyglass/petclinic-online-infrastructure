locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "jenkins_sg"
      description = "Allow Jenkins Traffic"
      ingress = {
        description      = "Allow from Personal CIDR block"
        from_port        = 8081
        to_port          = 8081
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }

      ingress = {
        description      = "Allow SSH from Personal CIDR block"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
      }

      egress = {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }

      tags = {
        Name = "Jenkins SG"
      }
    }
  }
}