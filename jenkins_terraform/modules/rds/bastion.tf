
resource "aws_instance" "bastion" {
  // general info
  ami                         = var.ami_id
  instance_type               = var.bastion_instance_type
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id
  key_name                    = aws_key_pair.SH-bastion_key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion_security.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  tags = { Name               = "bastion-SH" }

  // startup script
  user_data                   = templatefile("${path.module}/bastion_init.sh", {
    DB_ENDPOINT   = aws_db_instance.rds.address
    DB_USERNAME   = var.db_username
    DB_PASSWORD   = var.db_password
    DB_NAME       = var.db_name
  })
}

resource "aws_security_group" "bastion_security" {
  name = "bastion-security-SH"
  description = "Allow all SSH"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-security-SH"
  }
}

resource "aws_key_pair" "SH-bastion_key" {
  key_name = var.bastion_ssh_keyname
  public_key = <<-EOT
      ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBPtqIBQk8/fa0z2Kz31x7USWIY21cFQXEQTkJCKy8zTj6nDNZ4cLr1oFoQfIzaXygVz+cKwjmLG
      /qK6LT4NycNCwGDcZUhMKGSrP1Q0gGOw8LpUvZcFR0mYQsBi0Ct6ILPKZFkSOfgaNfndO8n5U+Kil2FGf7jxErBB7aFJjLiUrKzQFZPoXVeFBhzoHq
      8qYU38v+rIRYOff/lgQa5VeXD4yzeiV6jDWeWWBz9XiCWItYd6hfnt7pEMgggHdPtj6QxXc35zKvSSMUO/y5JyyHEFbhGoliThmQr55ex+VC9eNWRZ
      anxMBmajuGpKrTnCmhChBhYikEV0PfbYQvxWi4tq6yEzjAQ3iXIlZpwEX2RvMIzi6uHLR0be3cedCirvQTtfiS5MqjBWxO0scvVPBPuNts3xY+M0DS
      3ySEktlaW0IiQsAc/wc1T4X308dGsJLQva5lNoNLHLi9pyTxjETBkPHgyfqJRfePhVdsI4+UcOnLdetqa22Zb8+7hF1rwC8= sean@thor
      EOT
}
