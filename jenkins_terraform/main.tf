terraform {
    backend "s3" {
      region = "us-west-2"
      bucket = "sh-utopia-bucket"
      key = "state.tfstate"
  }
}


data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = "prod/SeanH/utopia_secrets"
}

data "aws_ecr_repository" "ecr-bookings" {
  name = "utopia_backend_bookings_microservice-sh"
}

data "aws_ecr_repository" "ecr-flights" {
  name = "utopia_backend_flights_microservice-sh"
}

data "aws_ecr_repository" "ecr-users" {
  name = "utopia_backend_users_microservice-sh"
}

data "aws_ecr_repository" "ecr-auth" {
  name = "utopia_backend_security_microservice-sh"
}

data "aws_ecr_repository" "ecr-data-producers" {
  name = "utopia_backend_data_producers_microservice-sh"
}

data "aws_ecr_repository" "ecr-admin" {
  name = "utopia_frontend_admin_microservice-sh"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.secrets.secret_string
  )
  zone_id = "Z02774322V8FI017JONWO"
}

module "network" {
  source                      = "./modules/network"
  vpc_cidr                    = "10.0.0.0/16"
  vpc_subnet_1_private_cidr   = "10.0.1.0/24"
  vpc_subnet_2_private_cidr   = "10.0.2.0/24"
  vpc_subnet_1_public_cidr    = "10.0.3.0/24"
  vpc_subnet_2_public_cidr    = "10.0.4.0/24"
  route_cidr                  = "0.0.0.0/0"
  zone_1                      = "us-west-2a"
  zone_2                      = "us-west-2b"
}

module "utopia-db" {
  source                = "./modules/rds"
  db_instance_class     = "db.t3.small"
  db_name               = "utopia"
  db_engine             = "mysql"
  db_engine_version     = "8.0.23"
  subnet_group_id       = module.network.subnet_group_id
  public_subnet_id      = module.network.all_subnets[2]
  vpc_id                = module.network.utopia_vpc
  db_username           = local.db_creds.DB_USERNAME
  db_password           = local.db_creds.DB_PASSWORD
  ami_id                = "ami-00f7e5c52c0f43726"
}

module "ecs" {
  source          = "./modules/ecs"
  r53_zone_id     = local.zone_id
  vpc_id          = module.network.utopia_vpc
  service_subnets = [module.network.all_subnets[2]]
}
