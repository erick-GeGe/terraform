provider "google" {
    version = "3.20.0"

    credentials = file("key.json")

    project = "axial-life-371817"
    region = "us-central1"
    zone = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
    name = "new-terraform-network"
}