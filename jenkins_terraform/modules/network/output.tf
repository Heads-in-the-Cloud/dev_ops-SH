

// Variables for outside use

// private subnet group for database use
output "subnet_group_id" {
  value = aws_db_subnet_group.subnet_group_private.id
}

// all subnets - choose privates as [0, 1] or publics as [2, 3]
output "all_subnets" {
  value = [ aws_subnet.private_subnet_1.id,
            aws_subnet.private_subnet_2.id,
            aws_subnet.public_subnet_1.id,
            aws_subnet.public_subnet_2.id ]
}

// vpc to use across the program
output "utopia_vpc" {
  value = aws_vpc.vpc-db-sh.id
}
