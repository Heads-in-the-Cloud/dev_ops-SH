
output "ALB_ID" {
  value = aws_lb.utopia_nwb.id
}

output "ALB_ENDPOINT" {
  value = aws_lb.utopia_nwb.dns_name
}

output "SECURITY_GR" {
  value = aws_security_group.ecs_api_security.id
}
