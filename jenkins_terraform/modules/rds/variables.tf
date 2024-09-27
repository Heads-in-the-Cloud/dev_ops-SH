
// Database Info

variable "db_engine" {
  type = string
  default = "mysql"
}

variable "db_engine_version" {
  type = string
  default = "8.0.23"
}

variable "db_instance_class" {
  type = string
  default = "db.t3.small"
}

variable "db_name" {
  type = string
  default = "utopia"
}

variable "db_username" {
  type = string
  default = ""
}

variable "db_password" {
  type = string
  default = ""
}


// Networking Info


variable "subnet_group_id" {
  type = string
  default = ""
}

variable "public_subnet_id" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
  default = ""
}


// Bastion Info


variable "ami_id" {
  type = string
  default = ""
}

variable "bastion_instance_type" {
  type = string
  default = "t2.micro"
}

variable "bastion_ssh_keyname" {
  type = string
  default = "SH-bastion_key"
}
