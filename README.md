# MoSIG2-GCP-Lab
Lab Assignment for the Cloud Computing course of MoSIG M2 2024

# Table of contents
- [MoSIG2-GCP-Lab](#mosig2-gcp-lab)
- [Table of contents](#table-of-contents)
- [Base steps](#base-steps)
  - [Step 1: Deploying the original application in GKE](#step-1-deploying-the-original-application-in-gke)
  - [Step 2: Analyzing the provided configuration](#step-2-analyzing-the-provided-configuration)
  - [Step 3: Deploying the load generator on a local machine](#step-3-deploying-the-load-generator-on-a-local-machine)
  - [Step 4: Deploying automatically the load generator in Google Cloud](#step-4-deploying-automatically-the-load-generator-in-google-cloud)
- [Advanced steps](#advanced-steps)
  - [Step 5: Monitoring the application and the infrastructure](#step-5-monitoring-the-application-and-the-infrastructure)
  - [Step 6: Performance evaluation](#step-6-performance-evaluation)
  - [Step 7: Canary releases](#step-7-canary-releases)
- [Bonus steps](#bonus-steps)
- [Credits](#credits)

# Base steps
## Step 1: Deploying the original application in GKE
## Step 2: Analyzing the provided configuration
For the paymentservice in the `/kubernetes_manifest.yaml`:
It is an important service, only letting 5 seconds of stuck state before termination. This also can be seen in the securityContext part, only limiting to one user ID, one user Group, and with the possibility to run it as non root.
This non-root policy is also seen in the only container this service has, as it doesn't allow privilege escalation. It also allows only read operations on the root of the machine, making it even safer.
This service, available through the 50051 port, will be using between 0.1 and 0.2 CPU, and between 64Mi and 128Mi of RAM. Does not seem to have any replicas whatsoever.
## Step 3: Deploying the load generator on a local machine
## Step 4: Deploying automatically the load generator in Google Cloud

# Advanced steps
## Step 5: Monitoring the application and the infrastructure
## Step 6: Performance evaluation
## Step 7: Canary releases

# Bonus steps
# Bibliography
[Kubernetes configuration documentation](https://kubernetes.io/docs/tasks/configure-pod-container/)
# Credits
This assignment was done by:
- Jules SEBAN (Jules.Seban@etu.univ-grenoble-alpes.fr)
- Gurvan CHEVALIER (Gurvan.Chevalier@etu.univ-grenoble-alpes.fr)
