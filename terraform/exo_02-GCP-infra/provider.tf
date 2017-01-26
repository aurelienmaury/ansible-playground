provider "google" {
  credentials = "${file("${path.module}/secrets/Ansible-7ab669a82b50.json")}"
  project     = "pelagic-pager-155923"
  region      = "europe-west1"
}