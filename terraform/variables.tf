terraform {
  required_version = "~> 0.12"
}

provider "aws" {
  version = "~> 3.9"
  region  = "ap-northeast-1"
  profile = "yoshino"
}
