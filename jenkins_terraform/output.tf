
output "AWS_VPC_ID" {
  value = module.network.utopia_vpc
}

output "AWS_RDS_ENDPOINT" {
  value = module.utopia-db.db_address
}

output "AWS_ALB_ID" {
  value = module.ecs.ALB_ID
}

output "AWS_ALB_ENDPOINT" {
  value = module.ecs.ALB_ENDPOINT
}
