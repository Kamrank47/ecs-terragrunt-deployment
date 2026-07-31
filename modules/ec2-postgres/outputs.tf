output "postgres_private_ip" {
  value = aws_instance.postgres.private_ip
}

output "postgres_instance_id" {
  value = aws_instance.postgres.id
}