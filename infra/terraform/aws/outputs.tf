output "ecr_repository_url" {
  value = aws_ecr_repository.api.repository_url
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.this.address
}

output "db_password_secret_arn" {
  value = aws_secretsmanager_secret.db_password.arn
}
