# Example: Single Participant Configuration
# Use this when you have only 1 participant

aws_region  = "us-east-1"
environment = "interview-single"

participants = {
  "devops" = ["john"]
}

group_size              = 3
password_reset_required = true
create_access_keys      = true

additional_tags = {
  Session = "Interview-Session-001"
}
