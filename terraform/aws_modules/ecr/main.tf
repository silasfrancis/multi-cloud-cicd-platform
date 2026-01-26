terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

resource "aws_ecr_repository" "devops_api" {
  name = "silasfrancis/devops-api"
}

resource "aws_ecr_repository" "db_migration" {
  name = "silasfrancis/db-migration"
}

resource "aws_ecr_repository" "devops_client" {
  name = "silasfrancis/devops-client"
}


resource "aws_ecr_lifecycle_policy" "devops_api_policy" {
  repository = aws_ecr_repository.devops_api.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "db_policy" {
  repository = aws_ecr_repository.db_migration.name

   policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "react_recoil_policy" {
  repository = aws_ecr_repository.devops_client.name

   policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 30 images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}