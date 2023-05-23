# aws_ecr_repository.my_ecr_repo.repository_url

# ------------------------------
# ECR
# ------------------------------
resource "aws_ecr_repository" "my_ecr_repo" {
  name = "my-ecr-repo"
}

resource "aws_ecr_repository" "fe" {
  name = "drits-manager-fe-temp"
}