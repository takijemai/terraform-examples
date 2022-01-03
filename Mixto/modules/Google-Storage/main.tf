

resource "google_storage_bucket" "jt800-storage" {
  name        = var.gcp_bucket_name
  location    = "EU"
  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

}


resource "google_storage_bucket_object" "image" {
  name   = "image1"
  source = "images/el_enigma_de_la_habitacion_622.jpg"
  bucket = google_storage_bucket.jt800-storage.name
  
}


resource "google_storage_bucket_object" "fotos" {
  name   = "image2"
  source = "images/una_historia_de_espana.jpg"
 bucket = google_storage_bucket.jt800-storage.name
  
}
resource "google_storage_bucket_acl" "jt800-storage-acl" {
  bucket = google_storage_bucket.jt800-storage.name
  role_entity = [
    "READER:AllUsers",
  ]
}
