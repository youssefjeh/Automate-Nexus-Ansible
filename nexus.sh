#!/bin/bash

# Install OpenJDK
sudo apt-get update
sudo apt-get install -y openjdk-11-jdk
sudo apt-get install net-tools

# Download Nexus Repository Manager 3
cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar xzf latest-unix.tar.gz

# Extract the downloaded archive
tar xzf latest-unix.tar.gz

# Rename the extracted directory to "nexus"
mv nexus-* nexus

# Move the nexus directory to /opt
sudo mv nexus /opt

# Create a nexus user and group
sudo useradd --system --no-create-home nexus
sudo groupadd --system nexus
sudo usermod -aG nexus nexus

# Change ownership of the nexus directory to the nexus user and group
sudo chown -R nexus:nexus /opt/nexus

# Configure Nexus to run as a service
sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOF
[Unit]
Description=Nexus Repository Manager

[Service]
Type=forking
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start the Nexus service
sudo systemctl start nexus

# Enable the Nexus service to start on boot
sudo systemctl enable nexus

ps aux | grep nexus
netstat -lnpt
