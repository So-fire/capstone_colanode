terraform {
  backend "s3" {
    encrypt = true
    bucket  = "colanode-tfstate"
    key     = "infra.tfstate"
    region  = "us-east-1"
    # profile        = "default"
  }
}
