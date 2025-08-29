output "public_ip" {
  value = google_compute_instance.p20.network_interface[0].access_config[0].nat_ip
}

output "instance_id" {
  value = google_compute_instance.p20.id
}