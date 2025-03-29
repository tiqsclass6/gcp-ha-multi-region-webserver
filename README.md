# 🌍 GCP Highly Available Global Web Server — User Guide

This guide walks you through deploying and managing a highly available, multi-region, autoscaling web server infrastructure using **Google Cloud Platform (GCP)** and **Terraform**.

---

## 🚀 Overview

This solution creates a production-grade web infrastructure with:

- ✅ **Global HTTP Load Balancer**
- ✅ **Managed Instance Groups (MIGs)** in 4 regions:
  - `us-central1`
  - `europe-west1`
  - `asia-northeast1` (Tokyo)
  - `southamerica-east1` (São Paulo)
- ✅ **Autoscaling** (min: 2, max: 5)
- ✅ **Apache Web Server** with a custom startup script
- ✅ **Regional VPC subnets**, **NAT gateway**, and **firewall rules**
- ✅ **Monitoring** with uptime checks

---

## 🔧 Prerequisites

- A Google Cloud Project with billing enabled
- IAM permissions to manage Compute, VPC, and Monitoring resources
- [Terraform](https://www.terraform.io/downloads) installed
- *(Optional)* [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) for manual validation

---

## 📁 Directory Structure

| File                              | Purpose                                  |
| --------------------------------- | ---------------------------------------- |
| `1-providers.tf`                  | Google provider setup                    |
| `2-vpc.tf`                        | VPC definition                           |
| `4b-subnets.tf`                   | Subnets for US, Europe, Tokyo, São Paulo |
| `3-security-group.tf`             | Firewall rules for web traffic           |
| `4-nat.tf`                        | NAT Gateway setup                        |
| `5-instance-template.tf`          | Default template                         |
| `5b-instance-templates-global.tf` | Per-region instance templates            |
| `6-backend.tf`                    | MIGs + autoscaling                       |
| `7-frontend.tf`                   | Load balancer configuration              |
| `8-firewall.tf`                   | Health check access rules                |
| `9-variables.tf`                  | Configurable inputs                      |
| `10-outputs.tf`                   | Key output values                        |
| `11-uptime-check.tf`              | Global uptime monitoring                 |
| `startup-script.sh`               | Apache setup script                      |

---

## 🛠️ Deployment Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/tiqsclass6/gcp-highly-available-web-server.git
cd gcp-highly-available-web-server
```

### 2. Configure Variables

Edit `9-variables.tf` directly:

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

### 4. Format Terraform Configuration

```bash
terraform fmt
```

This ensures consistent code formatting.

### 5. Validate Terraform Configuration

```bash
terraform validate
```

This checks that your configuration is syntactically valid and internally consistent.

### 6. Apply Infrastructure

```bash
terraform apply
```

Confirm the prompt and wait for provisioning to complete.

---

## 🌐 Access the Web Server

After deployment, Terraform will output the load balancer IP:

```ini
load_balancer_ip = "XX.XX.XX.XX"
```

Visit `http://<load_balancer_ip>` in your browser to view the globally distributed Apache web server.

---

## 📊 Monitoring & Health Checks

- Google Cloud Monitoring uptime checks are **enabled**
- Load balancer uses **HTTP health checks** to remove unhealthy instances
- Autoscaling is triggered based on **CPU utilization**

---

## 🫼 Cleanup

To destroy all resources created by Terraform:

```bash
terraform destroy
```

This will clean up all associated GCP infrastructure.

---

## 🦘 Troubleshooting

| Issue                       | Solution                                                   |
| --------------------------- | ---------------------------------------------------------- |
| Instances show as unhealthy | Verify Apache is running and port 80 is open               |
| Health check failing        | Confirm `/` is correctly served by the `startup-script.sh` |
| Load balancer shows 502     | Ensure all instance groups are healthy                     |
| Uptime check error          | Make sure Monitoring API is enabled in your GCP project    |

---

## 🙌 Credits

Created and maintained by **TIQS Class 6**\
*Infrastructure-as-Code for Cloud Excellence* 🌎🚀
