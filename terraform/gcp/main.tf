resource "google_compute_instance" "p20" {
  name         = "${var.project_name}-gcp"
  machine_type = var.machine_type
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  
  network_interface {
    network = "default"
    
    access_config {
      // Ephemeral public IP
    }
  }
  
  metadata = {
    ssh-keys = "debian:${file("${path.module}/../keys/p20-key.pub")}"
  }
  
  tags = ["http-server"]
}

resource "google_compute_firewall" "p20" {
  name    = "${var.project_name}-allow-web-ssh"
  network = "default"
  
  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}