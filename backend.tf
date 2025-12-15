# Terraform State Configuration
# Remote state management using S3 backend

terraform {
  backend "s3" {
    bucket  = "terraform-kamalb"
    key     = "hackathon/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}


