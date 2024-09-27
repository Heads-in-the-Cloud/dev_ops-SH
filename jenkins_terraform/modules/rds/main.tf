
// AWS RDS Instance
resource "aws_db_instance" "rds" {
  allocated_storage     = 10
  engine                = var.db_engine
  engine_version        = var.db_engine_version
  instance_class        = var.db_instance_class
  name                  = var.db_name
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = var.subnet_group_id
  vpc_security_group_ids = [aws_security_group.db_security.id]
  skip_final_snapshot   = true
  tags = {
    Name = "terraform-db-SH"
  }
}

// RDS Security Group
resource "aws_security_group" "db_security" {
  name          = "rds-security-SH"
  description   = "Allow all SSH and SQL traffic"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-SH"
  }
}
