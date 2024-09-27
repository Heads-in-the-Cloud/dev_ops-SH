
// Variables for outside use

// subnet group for database use
output "db_address" {
  value = element(split(":", aws_db_instance.rds.endpoint), 0)
}

output "bastion_public_id" {
  value = aws_instance.bastion.public_ip
}
