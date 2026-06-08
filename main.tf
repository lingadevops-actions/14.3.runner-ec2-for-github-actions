# Self hosted runner creation in Github Actions.
resource "aws_instance" "runner_ec2" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.main_sg.id]
  subnet_id = "subnet-0ea9a2005fdcc6695" #replace your Subnet

  # need more for terraform
  root_block_device {
    volume_size = 100
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("runner.sh")
  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-runner-ec2"
    }
  )
}

resource "aws_route53_record" "runner_ec2_r53" {
    zone_id = var.zone_id
    name    = "runner.${var.domain_name}"
    type    = "A"
    ttl     = 1
    records = [aws_instance.runner_ec2.public_ip]
    allow_overwrite = true
}


resource "aws_security_group" "main_sg" {
  name        =  "${var.project}-${var.environment}-runner-sg"
  description = "Created to attatch runner"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-runner-sg"
    }
  )
}
