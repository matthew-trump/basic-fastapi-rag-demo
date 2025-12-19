data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service" identifiers = ["ecs-tasks.amazonaws.com"] }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "${var.project_name}-task-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = { Project = var.project_name }
}

resource "aws_iam_role_policy_attachment" "task_exec_attach" {
  role       = aws_iam_role.task_execution.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task_role" {
  name               = "${var.project_name}-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json
  tags = { Project = var.project_name }
}

# Allow read access to the DB password secret
data "aws_iam_policy_document" "task_role_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [aws_secretsmanager_secret.db_password.arn]
  }
}

resource "aws_iam_role_policy" "task_role_inline" {
  name   = "${var.project_name}-task-inline"
  role   = aws_iam_role.task_role.id
  policy = data.aws_iam_policy_document.task_role_policy.json
}
