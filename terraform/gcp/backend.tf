terraform {
  backend "gcs" {
    bucket = "p20tfstate"
    prefix = "terraform/state"
  }
}