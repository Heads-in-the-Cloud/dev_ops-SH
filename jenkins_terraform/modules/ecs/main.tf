

// ECS Resources

// load balancing
resource "aws_lb" "utopia_nwb" {
  name = "nwb-utopia-SH"
  internal = false
  load_balancer_type = "network"
  subnets = var.service_subnets
}

// route 53
resource "aws_route53_record" "utopia_record" {
  zone_id = var.r53_zone_id
  name = "sh-ecs.hitwc.link"
  type = "CNAME"
  ttl = "20"
  records = [aws_lb.utopia_nwb.dns_name]
}


// Security

variable "ingress_list" {
  type = list(number)
  description = "List of ingress ports to add to security group."
  default = [22, 5000, 5010, 5020, 5030, 5040, 5050]
}

resource "aws_security_group" "ecs_api_security" {
  name = "ecs-allow-apis-SH"
  description = "Open SSH and all API ports"
  vpc_id = var.vpc_id

  # Incoming ports 
  dynamic "ingress" {
    for_each    = var.ingress_list
    iterator    = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # outgoing coverage
  egress {
    from_port     = 0
    to_port       = 0
    protocol      = "-1"
    cidr_blocks   = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-apis-SH"
  }
}
