terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mhemani"

    workspaces {
      prefix = "ledn-take-home-"
    }
  }
}