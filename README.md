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
For this step, we had some issues with the limitations of some locations. They didn't allow as much ressources as we were requesting for. After trying some other Google datacenters, we finally had to use another project, managed with another billing account in order to do the implementations below.
## Step 2: Analyzing the provided configuration
This service has the main goal of charging the credit card given by the user with the cart amount.
When requested, it will try to charge one credit card (characterized by its number, CCV, expiration date and year) of an amount of money. Then, if the charging is a success, the charge response is a transaction.

It is an important service, only letting 5 seconds of stuck state before termination. This also can be seen in the securityContext part, only limiting to one user ID, one user Group, and with the possibility to run it as non root.

This non-root policy is also seen in the only container this service has, as it doesn't allow privilege escalation. It also allows only read operations on the root of the machine, making it even safer.

This service, available through the 50051 port, will be using between 0.1 and 0.2 CPU, and between 64Mi and 128Mi of RAM. Does not seem to have any replicas whatsoever.
## Step 3: Deploying the load generator on a local machine
In order to approach locust, we installed locust on a Fedora machine, with a simple locustfile.py that would just request the main page `/` of the online boutique. After entering the IP address of the boutique, 100 users max and 10 users every second, following the locust domumentation closely in the first place. We saw that this was doing pretty well, the users just doing their request and then idling. No issues encountered, with 0% failed requests. 

## Step 4: Deploying automatically the load generator in Google Cloud
The load generator has been seperated from the Kubernetes cluster and is now setup as an Infrastructure as Code (IaC) in the `load_generator` folder. It is using Terraform to provision the resources, and Ansible to configure the instance. 

The Terraform configuration let us choose the machine_type and the region (if we want a different one than the Kubernetes cluster). 

The Ansible configuration is used to install the Locust load generator in a Docker container on the instance, it allows for scalability by changing the number of workers in the `locust_config.yaml` file.

We had to expose the port 8089 of the instance by providing a firewall rule in the Terraform configuration, so we can still access the Locust web interface.

Now that we have an entire VM instance dedicated to load generation, we can really stress test the online-boutique application without impacting the cluster itself. Thus having a more realistic view of the application's performance.




# Advanced steps
## Step 5: Monitoring the application and the infrastructure
For this monitoring step, we have to use Prometheus and Grafana, alongside the node exporter of Prometheus.
First of all, Prometheus is a platform that is going to collect metrics from HTTP endpoints. It has it's own system of visualization, but for clarity and more reliability, we tend to use another open source software that is Grafana. It provides us with a performant live data visualizer. We can also use this to create custom dashboards with the data we really need for our project (being the CPU and memory consumption here).
But, in order to collect this type of data, we need a MITM, that'll request the Linux system datas and sends it to Prometheus: this is the role of the node exporter: communicate with all the nodes that we want in the pool and get some information that will be communicated to Prometheus through PromQL.
We have the Prometheus and the Grafana nodes ready in [metrics-kube.yaml](metrics-kube.yaml). They do have the minimum configuration and the node exporter isn't implemented yet. In order for them to work together, we should configure Prometheus to get launched with a prometheus.yml file, containing the infomations that it'll get infos from it's node exporter. Grafana can get easily the data source from an IP and the port of the prometheus node (it is sending the data directly through this way)
## Step 6: Performance evaluation
Now that we tried Locust far from our datacenter (on a client), we need, if we want to evaluate the actual performance of our infrastructure, we need to have it separated from the cluster of the boutique, and get this service out of it. But, the load generation should avoid to be far in distance from the datacenter in order to not take into account potential network issues, and actually benchmark our infrastructure. 
In order to have a realistic benchmark, we needed to have "users" generated by Locust that have a nearly realistic behaviour. To have this, we created in our locustfile a user that can do 2 main actions: request the main page, or search through the items of the store (we chose times from 100ms to 500ms, being not that realistic, but keeping us covered from users that use our site at a really high intensity).
We first tried with 1000 users at a rate of 50user/sec ramp up. We didn't notice any issue in the requests.
## Step 7: Canary releases

# Bibliography
[Kubernetes configuration documentation](https://kubernetes.io/docs/tasks/configure-pod-container/)
[Locust documentation](https://docs.locust.io/en/stable/quickstart.html)
[Prometheus documentation](https://prometheus.io/docs/introduction/first_steps/#starting-prometheus)
[Grafana with prometheus documentation](https://prometheus.io/docs/visualization/grafana/#installing)
[Node Exporter](https://prometheus.io/docs/guides/node-exporter/)

# Credits
This assignment was done by:
- Jules SEBAN (Jules.Seban@etu.univ-grenoble-alpes.fr)
- Gurvan CHEVALIER (Gurvan.Chevalier@etu.univ-grenoble-alpes.fr)
