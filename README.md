# MoSIG2-GCP-Lab
Lab Assignment for the Cloud Computing course of MoSIG M2 2024

# Table of contents
- [MoSIG2-GCP-Lab](#mosig2-gcp-lab)
- [Table of contents](#table-of-contents)
- [Setup guide](#setup-guide)
- [Base steps](#base-steps)
  - [Step 1: Deploying the original application in GKE](#step-1-deploying-the-original-application-in-gke)
  - [Step 2: Analyzing the provided configuration](#step-2-analyzing-the-provided-configuration)
  - [Step 3: Deploying the load generator on a local machine](#step-3-deploying-the-load-generator-on-a-local-machine)
  - [Step 4: Deploying automatically the load generator in Google Cloud](#step-4-deploying-automatically-the-load-generator-in-google-cloud)
- [Advanced steps](#advanced-steps)
  - [Step 5: Monitoring the application and the infrastructure](#step-5-monitoring-the-application-and-the-infrastructure)
  - [Step 6: Performance evaluation](#step-6-performance-evaluation)
  - [Step 7: Canary releases](#step-7-canary-releases)
- [Bibliography](#bibliography)
- [Credits](#credits)

# Setup guide
In order to run the provided scripts, you need to modify the [.env](.env) file with your own values, then do the same with the variables in the [main.tf](load_generator/main.tf) file. You can then run `chmod 700 *.sh load_generator/*.sh` to make the scripts executable, followed by `./setup.sh` to install the needed stuff. 

You can then run any `create_[...].sh` combined with `deploy_[...].sh` to provision and configure the resources you want, which are either the online-boutique (cluster) or the seperate load generator (Locust). 

You can also decide to change the number of Locust workers in the [locust_config.yaml](load_generator/locust_config.yaml) file, before deploying the load_generator. 

Finally, don't forget to use `./destroy.sh` to clean up the resources you created, so you don't get debited for used up resources.

PS: You may have to wait some time before launching the Locust deployement after the instance is created, otherwise the script will potentially try to connect to it before it is fully operational.

# Base steps
## Step 1: Deploying the original application in GKE
## Step 2: Analyzing the provided configuration
This service has the main goal of charging the credit card given by the user with the cart amount.
When requested, it will try to charge one credit card (characterized by its number, CCV, expiration date and year) of an amount of money. Then, if the charging is a success, the charge response is a transaction.

It is an important service, only letting 5 seconds of stuck state before termination. This also can be seen in the securityContext part, only limiting to one user ID, one user Group, and with the possibility to run it as non root.

This non-root policy is also seen in the only container this service has, as it doesn't allow privilege escalation. It also allows only read operations on the root of the machine, making it even safer.

This service, available through the 50051 port, will be using between 0.1 and 0.2 CPU, and between 64Mi and 128Mi of RAM. Does not seem to have any replicas whatsoever.

## Step 3: Deploying the load generator on a local machine
Done

## Step 4: Deploying automatically the load generator in Google Cloud
The load generator has been seperated from the Kubernetes cluster and is now setup as an Infrastructure as Code (IaC) in the `load_generator` folder. It is using Terraform to provision the resources, and Ansible to configure the instance. 

The Terraform configuration let us choose the machine_type and the region (if we want a different one than the Kubernetes cluster). 

The Ansible configuration is used to install the Locust load generator in a Docker container on the instance, it allows for scalability by changing the number of workers in the `locust_config.yaml` file.

We had to expose the port 8089 of the instance by providing a firewall rule in the Terraform configuration, so we can still access the Locust web interface.

Now that we have an entire VM instance dedicated to load generation, we can really stress test the online-boutique application without impacting the cluster itself. Thus having a more realistic view of the application's performance.



# Advanced steps
## Step 5: Monitoring the application and the infrastructure
## Step 6: Performance evaluation
## Step 7: Canary releases

# Bibliography
[Kubernetes configuration documentation](https://kubernetes.io/docs/tasks/configure-pod-container/)
# Credits
This assignment was done by:
- Jules SEBAN (Jules.Seban@etu.univ-grenoble-alpes.fr)
- Gurvan CHEVALIER (Gurvan.Chevalier@etu.univ-grenoble-alpes.fr)
