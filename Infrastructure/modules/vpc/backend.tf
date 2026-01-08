terraform {
  backend "s3" {
    bucket         = "astronomy-project-remote-state"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
