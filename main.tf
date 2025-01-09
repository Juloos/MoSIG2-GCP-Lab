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
  default     = "online-boutique"
}

variable "region" {
  type        = string
  default     = "europe-west6-a"
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-2"
}

variable "node_count" {
  type        = number
  default     = 4
}


provider "google" {
  project = var.project_id
  zone    = var.region
}

resource "google_container_cluster" "primary" {
  name                     = var.name
  deletion_protection      = false
  # Original comment:
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "preemptible-pool"
  cluster    = var.name
  node_count = var.node_count

  # Node pools are created and managed as separate resources to allow
  # them to be added and removed without recreating the entier cluster.
  node_config {
    preemptible  = true
    machine_type = var.machine_type
  }
}


# Based on microservices-demo/terraform/main.tf

# Apply YAML kubernetes-manifest configurations
resource "null_resource" "apply_deployment" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = "kubectl apply -f ./kubernetes-manifests.yaml"
  }
}

# Wait condition for all Pods to be ready before finishing
resource "null_resource" "wait_conditions" {
  provisioner "local-exec" {
    interpreter = ["bash", "-exc"]
    command     = <<-EOT
    kubectl wait --for=condition=AVAILABLE apiservice/v1beta1.metrics.k8s.io --timeout=180s
    kubectl wait --for=condition=ready pods --all --timeout=280s
    EOT
  }

  depends_on = [
    resource.null_resource.apply_deployment
  ]
}
