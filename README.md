# 🌐 GCP HA Multi-Region Web Server — Deployment Guide

This repository provisions a **highly available**, **multi-region**, and **autoscaling** web server infrastructure on **Google Cloud Platform (GCP)** using **Terraform**.

---

## 🚀 Project Overview

This infrastructure includes:

- 🌍 **Global HTTP Load Balancer**
- 🌎 **Managed Instance Groups (MIGs)** in 4 regions:
  - `us-central1` (Iowa)
  - `europe-west2` (London)
  - `asia-northeast1` (Tokyo)
  - `southamerica-east1` (São Paulo)
- 📈 **Autoscaling**: 2–5 VMs per region based on CPU utilization
- 🛠️ **Apache Web Server** installed via startup script
- 🌐 **VPC with per-region subnets**, **NAT gateway**, **firewalls**
- 🔎 **Monitoring**: Uptime checks via Google Cloud Monitoring

---

## 🔧 Prerequisites

- A GCP project with billing enabled
- IAM roles for Compute Admin, Network Admin, Monitoring Admin
- [Terraform CLI](https://www.terraform.io/downloads)
- *(Optional)* [gcloud CLI](https://cloud.google.com/sdk/docs/install)

---

## 📁 Directory Structure

```bash
.
├── 1-providers.tf               # Google provider configuration
├── 2-vpc.tf                     # VPC definition
├── 3-firewall.tf                # Firewall rules for HTTP and health checks
├── 4-nat.tf                     # NAT router and configuration
├── 5-subnets.tf                 # Subnets for each region
├── 6-instance-template.tf       # Instance templates for VM instances
├── 7-backend.tf                 # MIGs and autoscalers
├── 8-frontend.tf                # Load balancer and health check
├── 9-uptime-check.tf            # Uptime check configuration
├── 10-variables.tf              # Input variables
├── 11-outputs.tf                # Terraform output values
├── startup-script.sh            # Apache installation startup script
└── README.md                    # This documentation file
```

---

## 🛠️ Deployment Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/tiqsclass6/gcp-ha-multi-region-webserver.git
cd gcp-ha-multi-region-webserver
code .
```

### 2. Configure Variables

Directly modify `10-variables.tf`:

```hcl
project_id = "your-gcp-project-id"
region     = "us-central1"
vpc_name   = "ha-webserver-vpc"
vm_type    = "e2-micro"
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Format Terraform

```bash
terraform fmt
```

### 5. Validate Terraform

```bash
terraform validate
```

### 6. Apply the Infrastructure

```bash
terraform apply
```

Accept the prompt and wait a few minutes for provisioning.

---

## 🌐 Accessing the Web Server

After deployment, Terraform will output the load balancer’s IP:

```bash
load_balancer_ip = "XX.XX.XX.XX"
```

Navigate to:

```bash
http://<load_balancer_ip>
```

You’ll see your custom Apache server served globally.

---

## 📊 Monitoring & Uptime

- Google Cloud **uptime checks** are enabled
- **HTTP health checks** remove unhealthy instances
- **Autoscaling** triggers dynamically via CPU usage

---

## 🧼 Cleanup

To destroy all resources:

```bash
terraform destroy
```

---

## 🛠 Troubleshooting

| Problem                  | Solution                                                   |
|--------------------------|------------------------------------------------------------|
| MIGs show unhealthy      | Confirm Apache is running; port 80 is open                 |
| Health check fails       | Ensure `/` path is served by startup script                |
| 502 from Load Balancer   | Make sure instance groups are healthy                      |
| Uptime check error       | Ensure Monitoring API is enabled in GCP                    |

---
