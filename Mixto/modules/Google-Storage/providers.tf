terraform {
required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
credentials = file("../cc2021-jt800-d312ec601440.json")

  project = var."cc2021-jt800"
  region  = "us-central1"
  zone    = "us-central1-c"
}
