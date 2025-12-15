# Example: Large Scale Hackathon
# 50+ participants across multiple skill sets

aws_region  = "us-east-1"
environment = "hackathon-large-scale"

participants = {
  "devops" = [
    "dev1", "dev2", "dev3", "dev4", "dev5",
    "dev6", "dev7", "dev8", "dev9", "dev10",
    "dev11", "dev12", "dev13", "dev14", "dev15"
  ]

  "ai-engineer" = [
    "ai1", "ai2", "ai3", "ai4", "ai5",
    "ai6", "ai7", "ai8", "ai9", "ai10"
  ]

  "fullstack" = [
    "fs1", "fs2", "fs3", "fs4", "fs5",
    "fs6", "fs7", "fs8", "fs9", "fs10",
    "fs11", "fs12"
  ]

  "cloud-architect" = [
    "ca1", "ca2", "ca3", "ca4", "ca5",
    "ca6", "ca7", "ca8"
  ]

  "security" = [
    "sec1", "sec2", "sec3", "sec4", "sec5"
  ]
}

group_size              = 3
password_reset_required = true
create_access_keys      = true

additional_tags = {
  Event      = "Annual-Tech-Hackathon"
  Scale      = "Large"
  CostCenter = "Engineering"
}
