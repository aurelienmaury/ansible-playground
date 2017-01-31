variable "ssh_pub_key" {
  default = "./secrets/pub_key"
}

variable "gcp_credentials_path" {
  default = "./secrets/Ansible-5019d80bc497.json"
}

variable "gcp_region" {
  default = "europe-west1"
}

variable "gcp_project" {
  default = "pelagic-pager-155923"
}