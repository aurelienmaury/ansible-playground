provider "google" {
  credentials = "${file(var.gcp_credentials_path)}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}


resource "google_compute_network" "network" {
  name                    = "ansible-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "tf_network" {
  name          = "ansible-subnetwork"
  ip_cidr_range = "10.0.0.0/24"
  network       = "${google_compute_network.network.self_link}"
  region        = "europe-west1"
}

resource "google_compute_firewall" "public" {
  name    = "public"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  source_tags = ["public"]
}

resource "google_compute_instance" "bastion" {
  name         = "tf-training-bastion"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"
  tags         = ["bastion"]

  disk {
    image = "debian-8-jessie-v20170110"
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.tf_network.name}"

    access_config {
      # Ephemeral
    }
  }

  metadata {
    ssh-keys = "admin:${file(var.ssh_pub_key)}"
  }
}

output "bastion" {
  value = "${google_compute_instance.bastion.network_interface.0.access_config.0.assigned_nat_ip}"
}