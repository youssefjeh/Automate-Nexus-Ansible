#!/bin/bash

# Install OpenJDK
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk
sudo apt-get install net-tools


# Download Nexus Repository Manager 3
cd /opt
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
# Extract the downloaded archive
tar xzf latest-unix.tar.gz
# Rename the extracted directory to "nexus"
mv nexus-* nexus


# Create a nexus user and group
sudo useradd --system --no-create-home nexus
sudo groupadd --system nexus
sudo usermod -aG nexus nexus
# Change ownership of the nexus directory to the nexus user and group
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work


#Configure Nexus to run as a service
sudo vim nexus/bin/nexus.rc
run_as_user="nexus"
su - nexus
/opt/nexus/bin/nexus start

ps aux | grep nexus
netstat -lnpt
