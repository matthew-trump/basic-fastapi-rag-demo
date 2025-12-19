# AWS Terraform (rag-demo)

This Terraform creates:
- VPC (public + private subnets), IGW, NAT
- ECR repo
- ECS Fargate cluster/service behind an ALB
- RDS Postgres 16 in private subnets
- CloudWatch Logs
- Secrets Manager secret containing the DB password

## After apply
Terraform outputs:
- `ecr_repository_url`
- `alb_dns_name`
- `rds_endpoint`
- `db_password_secret_arn`

## Important: DATABASE_URL
This demo intentionally does NOT auto-wire `DATABASE_URL` for you because:
- many teams prefer secrets/SSM patterns that vary by org
- it’s good for you to see it explicitly

Recommended wiring:
1) Store a full `DATABASE_URL` in Secrets Manager (or SSM Parameter Store)
2) Reference it from the ECS task definition as a secret env var

Example DATABASE_URL format (psycopg/sqlalchemy):
`postgresql+psycopg://rag:<PASSWORD>@<RDS_ENDPOINT>:5432/rag`

To keep this repo small, you’ll add that in your next iteration.
