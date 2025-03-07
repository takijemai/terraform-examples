terraform {
required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
     
credentials = file("Mixto/gcp-identity.json")

  project = var.gcp-project
  region  = "us-central1"
  zone    = "us-central1-c"
}
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
