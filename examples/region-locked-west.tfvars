# Example: Region-Locked Hackathon in US West
# All users restricted to us-west-2 only

aws_region  = "us-west-2"
environment = "hackathon-west-coast"

participants = {
  "devops" = [
    "alice",
    "bob",
    "charlie"
  ]

  "ai-engineer" = [
    "david",
    "emma"
  ]
}

group_size              = 3
password_reset_required = true
create_access_keys      = true

additional_tags = {
  Event      = "West-Coast-Hackathon"
  Region     = "us-west-2"
  Restricted = "true"
}
