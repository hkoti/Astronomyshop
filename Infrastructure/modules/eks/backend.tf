data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = "astronomy-shop-project-remote-state"
    key            = "vpc/terraform.tfstate"
    region         = "ap-south-1"   # same as bucket
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
