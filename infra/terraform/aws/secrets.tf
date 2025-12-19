resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}/db_password"
  tags = { Project = var.project_name }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_password.db_password.result
}

resource "random_password" "db_password" {
  length  = 24
  special = true
}
