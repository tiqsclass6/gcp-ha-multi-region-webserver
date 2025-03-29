#!/bin/bash

# Update and install Apache2
apt-get update
apt-get install -y apache2

# Start and enable Apache2
systemctl start apache2
systemctl enable apache2

# GCP Metadata server base URL and header
METADATA_URL="http://metadata.google.internal/computeMetadata/v1"
METADATA_FLAVOR_HEADER="Metadata-Flavor: Google"

# Use curl to fetch instance metadata
LOCAL_IPV4=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/instance/network-interfaces/0/ip")
ZONE=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/instance/zone")
PROJECT_ID=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/project/project-id")
NETWORK_TAGS=$(curl -s -H "$METADATA_FLAVOR_HEADER" "$METADATA_URL/instance/tags")

# Create a simple HTML page with instance details
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

# Restart Apache to ensure it picks up the new content
systemctl restart apache2