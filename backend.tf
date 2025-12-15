# Terraform State Configuration (Optional but Recommended)
# Uncomment and configure for remote state management

# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "hackathon/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }
