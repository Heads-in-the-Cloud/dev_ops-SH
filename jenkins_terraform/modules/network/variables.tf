
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/0"
}

variable "vpc_subnet_1_private_cidr" {
  type = string
  default = ""
}

variable "vpc_subnet_2_private_cidr" {
  type = string
  default = ""
}

variable "vpc_subnet_1_public_cidr" {
  type = string
  default = ""
}

variable "vpc_subnet_2_public_cidr" {
  type = string
  default = ""
}

variable "route_cidr" {
  type = string
  default = ""
}

variable "zone_1" {
  type = string
  default = ""
}

variable "zone_2" {
  type = string
  default = ""
}
