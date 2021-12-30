terraform {
required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
     version = "3.5.0"
credentials = file("../gcp-identity.json")

  project = var.gcp-project
  region  = "us-central1"
  zone    = "us-central1-a"
}
