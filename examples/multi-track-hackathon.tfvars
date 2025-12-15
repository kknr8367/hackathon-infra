# Example: Multiple Skill Sets with Different Group Sizes
# Use this for a diverse hackathon with multiple tracks

aws_region  = "us-east-1"
environment = "hackathon-multi-track"

participants = {
  "devops" = [
    "kamal",
    "abdul",
    "john",
    "jane",
    "mike",
    "sarah",
    "tom",
    "alice"
  ]

  "ai-engineer" = [
    "alex",
    "emma",
    "chris",
    "diana"
  ]

  "fullstack" = [
    "david",
    "lisa",
    "mark"
  ]

  "data-engineer" = [
    "rachel",
    "steve"
  ]
}

group_size              = 3
password_reset_required = true
create_access_keys      = true

additional_tags = {
  Event      = "December-Hackathon-2024"
  CostCenter = "Engineering"
  Duration   = "3-days"
}
