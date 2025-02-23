terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.8.0"
    }
  }
}


variable "project_id" {
  type        = string
  default     = "online-boutique-cloud-m2-jules"
}

variable "name" {
  type        = string
  default     = "online-boutique-load-generator"
}

variable "zone" {
  type        = string
  default     = "europe-west1-b"
}

variable "machine_type" {
  type        = string
  default     = "f1-micro"
}


provider "google" {
  project = var.project_id
  zone    = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = var.name
  count        = 1
  machine_type = var.machine_type

  tags = ["webui"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "default" {
 name    = "load-generator-firewall"
 network = "default"

 allow {
   protocol = "icmp"
 }

 allow {
   protocol = "tcp"
   ports    = ["8089"]
 }

 source_ranges = ["0.0.0.0/0"]
 target_tags = ["webui"]
}

// A variable for extracting the external ip of the instance
output "ip" {
  value = "${google_compute_instance.vm_instance[0].network_interface.0.access_config.0.nat_ip}"
}
