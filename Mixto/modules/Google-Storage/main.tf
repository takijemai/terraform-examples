
resource "google_storage_bucket" "image-store" {
  name        = "image-store-bucket"
  location    = "EU"

}


resource "google_storage_bucket_object" "image" {
  name   = "el_enigma_de_la_habitacion"
  source = "./images/el_enigma_de_la_habitacion_622.jpg"
  bucket = "image-store"
}


resource "google_storage_bucket_object" "image2" {
  name   = "una_historia_de_espana"
  source = "./images/una_historia_de_espana.jpg"
 bucket = "image-store"
  
}
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = "image-store"
  role   = "READER"
  entity = "allUsers"
}

