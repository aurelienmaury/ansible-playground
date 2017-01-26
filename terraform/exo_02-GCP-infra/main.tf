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
    ssh-keys = "admin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/PW7tS5jF5rwSCiTD6bnlovTyS7MPJeI2/uv2nY5W5ZA5WmYPUpCFr0rAnhHoemwCqRfP5pj7KRv17r8m97iEt/U9HlaXxKPtpUZ96oWbfePemZnHITY4f4QFlhyuMm4cIO6j01LyOyMd5n9FLrN4S9IReSRmlDOw+L10DVEfAxn+3nGdzv/vGuwUkgSLSUiLrXxQWcwMHMtmkhv1oTIT4j07jVK2OdSlN4jj/BwQnPDw+I8F2KTOghs4+NPnATUxK6cp2uiDpgaxKMinzvZHR1vIBVuyVUyJ+Sm85+jOTFO08tpSq/LenYQMuLq1SddEhV5pwKa+xSUnOo9htgRr amaury@MacBook-Pro-de-Aurelien.local"
  }
}
