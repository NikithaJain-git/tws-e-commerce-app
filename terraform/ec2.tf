data "aws_ami" "os_image" {
    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "state"
        values = ["available"]
    }
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64**"]
    }
}

resource "aws_key_pair" "key_pair" {
    key_name = "terra-key"
    public_key = file("terra-key-pub")
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow_user_to_connect" {
    name = "allow TLS"
    description = "allow user to connect"
    vpc_id = aws_default_vpc.default.id

    ingress {
        description = "allow port for ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "allow port for all outgoing traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow port for http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow port for https"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow port for jenkins"
        from_port = 8080
        to_port =  8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "allow port for nodeport"
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags = {
        name = "mysecurity_groups"
    }

}

resource "aws_instance" "ec2_instance" {
    ami = data.aws_ami.os_image.id
    instance_type = var.instance_type
    key_name = aws_key_pair.key_pair.key_name
    security_groups = [aws_security_group.allow_user_to_connect.name]
    tags = {
        name = "Ec2_instance_automate"
    }

    root_block_device {
      volume_size = 30
      volume_type = "gp3"
    }
}
