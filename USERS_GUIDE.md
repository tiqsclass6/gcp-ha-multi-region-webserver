# Deploying GCP HA Multi-Region Web Server via Console

This guide walks you through **manual setup using the Google Cloud Console**, without Terraform. It replicates the architecture of a globally distributed, autoscaling web application.

---

## 🌍 Architecture Overview

- Global HTTP(S) Load Balancer
- Managed Instance Groups in:
  - `us-central1` (Iowa)
  - `europe-west1` (London)
  - `asia-northeast1` (Tokyo)
  - `southamerica-east1` (São Paulo)
- Apache Web Servers with startup scripts
- Subnets, NAT Gateway, and firewall rules
- Health checks and uptime monitoring

---

## 🔧 Prerequisites

- A GCP Project with billing enabled
- Owner or Admin IAM role on the project

---

## 🛠️ Step-by-Step Instructions (via Console)

### 1. Create VPC Network

- Go to **VPC Network > VPC networks**
- Click **Create VPC**
  - Name: `ha-webserver-vpc`
  - Subnet creation mode: **Custom**

### 2. Create Subnets (One for Each Region)

- Inside the VPC, create 4 subnets:
  - `subnet-us` — `us-central1` — `10.10.0.0/24`
  - `subnet-europe` — `europe-west1` — `10.20.0.0/24`
  - `subnet-tokyo` — `asia-northeast1` — `10.30.0.0/24`
  - `subnet-sao-paulo` — `southamerica-east1` — `10.40.0.0/24`

### 3. Create Firewall Rules

- Go to **VPC Network > Firewall**
- Create 2 rules:
  - `allow-http`: allow `tcp:80` from `0.0.0.0/0` to targets with tag `http-server`
  - `allow-health-checks`: allow `tcp:80` from `130.211.0.0/22` and `35.191.0.0/16`

### 4. Create NAT Gateway

- Go to **NAT > Routers**, create a router for each region
- Under **NAT Gateway**, create NATs using those routers
  - Use `Auto allocate IP`

### 5. Create Instance Templates (One per Region)

- Go to **Compute Engine > Instance templates**
- For each region, create a template:
  - Set region-specific subnet (e.g., `subnet-tokyo`)
  - Add **startup script** to install Apache:

    ```bash
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    
    METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
    METADATA_FLAVOR_HEADER="Metadata-Flavor: Google"
    
    LOCAL_IPV4=$(curl -s -H "$METADATA_FLAVOR_HEADER"
    "$METADATA_URL/instance/network-interfaces/0/ip")
    ZONE=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/instance/zone")
    PROJECT_ID=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/project/project-id")
    NETWORK_TAGS=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/instance/tags")
    
    cat <<EOF > /var/www/html/index.html
    <!DOCTYPE html>
    <html>
    <head>
    <title>GCP Highly Available (HA) Webserver</title>
    </head>
    <body style="background-image: url('https://img.freepik.com/premium-photo/flag-wallpaper-brazil_670382-35283.jpg'); background-size: cover; background-position: center; color: white; text-align: center; font-family: Arial, sans-serif; padding: 20px;">
    <h1>Multi-Region (HA) GCP Server</h1>
    <img src="https://www.sanclerfrantz.com.br/extranet/gallery/50.jpg" alt="Theo's Blonde" width="527" height="791">
    <p><b>Instance Name:</b> $(hostname -f)</p>
    <p><b>Instance Private IP Address:</b> $LOCAL_IPV4</p>
    <p><b>Zone:</b> $ZONE</p>
    <p><b>Project ID:</b> $PROJECT_ID</p>
    <p><b>Network Tags:</b> $NETWORK_TAGS</p>
    <img src="https://colorsuper.com/cdn/shop/files/Colorsuper-Bikini-Low-Rise-Super-Bikini-Visual-Nitro-Pink-Green-Yellow-001.jpg" alt="TIQS Afro-Braziliana" width="633" height="791">
    </body>
    </html>
    EOF
    systemctl restart apache2
    ```

  - Add tag: `http-server`

### 6. Create Managed Instance Groups

- Go to **Compute Engine > Instance groups**
- For each region:
  - Use the corresponding template
  - Enable autoscaling: min 2, max 5
  - Select the correct region & zone

### 7. Create Health Check

- Go to **Load Balancing > Health Checks**
- Create HTTP health check
  - Port: 80, Path: `/`

### 8. Create Backend Service

- Go to **Load Balancing > Backend Services**
- Create backend service, add all 4 MIGs
- Attach the health check

### 9. Create URL Map, HTTP Proxy, and Global Forwarding Rule

- URL map: point to backend service
- HTTP proxy: point to URL map
- Global forwarding rule:
  - Port: 80
  - IP: Automatically assigned

### 10. Set Up Monitoring

- Go to **Monitoring > Uptime Checks**
- Create check for load balancer IP at port 80

---

## 🌐 Testing

- Visit the external IP from the forwarding rule
- You should see the hostname of a region-specific VM

---

## 🧼 Teardown in Google Console

To clean up all deployed resources via the console:

1. **Load Balancer**
   - Navigate to **Network Services > Load balancing**
   - Delete the forwarding rule, target proxy, URL map, and backend service

2. **Health Check**
   - Go to **Network Services > Health checks** and delete the HTTP check

3. **Managed Instance Groups**
   - Go to **Compute Engine > Instance groups** and delete all 4 MIGs

4. **Instance Templates**
   - Go to **Compute Engine > Instance templates** and delete all templates

5. **NAT Gateways & Routers**
   - Go to **VPC network > NAT** and delete NAT configs and routers

6. **Firewall Rules**
   - Go to **VPC network > Firewall rules** and delete `allow-http` and `allow-health-checks`

7. **Subnets**
   - Go to **VPC network > VPC networks**, click on the VPC, and delete the 4 custom subnets

8. **VPC Network**
   - Once subnets are deleted, delete the entire VPC network

9. **Uptime Checks**
   - Go to **Monitoring > Uptime checks** and delete the check for the load balancer

---
