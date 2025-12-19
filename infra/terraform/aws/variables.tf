variable "aws_region" { type = string  default = "us-west-2" }
variable "project_name" { type = string default = "rag-demo" }

variable "image_tag" { type = string default = "latest" }

# RDS
variable "db_name" { type = string default = "rag" }
variable "db_username" { type = string default = "rag" }
variable "db_instance_class" { type = string default = "db.t4g.micro" } # cheap-ish ARM; RDS can be arm
variable "db_allocated_storage" { type = number default = 20 }

# App
variable "app_port" { type = number default = 8011 }
variable "desired_count" { type = number default = 1 }

# OpenAI
variable "openai_model" { type = string default = "gpt-5" }
variable "openai_embedding_model" { type = string default = "text-embedding-3-small" }
