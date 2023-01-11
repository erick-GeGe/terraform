resource "google_compute_instance_template" "my_instance" {
    name = "my-instance-template"
    machine_type = "e2-micro"
    can_ip_forward = false
    project = "axial-life-371817"
    tags = ["foo", "bar", "allow-lb-service"]

    disk {
        source_image      = "debian-cloud/debian-11"
        auto_delete       = true
        boot              = true
    }
    network_interface {
        network = google_compute_network.vpc_network.name
        access_config {
        }
    }

    metadata_startup_script = file("init.sh")
    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}

resource "google_compute_firewall" "ssh" {
    name = "allow-ssh"
    allow {
        ports    = ["22"]
        protocol = "tcp"
    }
    direction     = "INGRESS"
    network       = google_compute_network.vpc_network.id
    priority      = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["ssh"]
}

resource "google_compute_firewall" "flask" {
    name    = "flask-app-firewall"
    network = google_compute_network.vpc_network.id

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }
    source_ranges = ["0.0.0.0/0"]
}