#!/bin/bash

sudo apt-get install -y apache2

COLOR="blue"
INSTANCE_ID=$(cat /var/lib/cloud/data/instance-id)
INSTANCE_ID=$(cat /var/lib/cloud/data/instance-id)
AMI_ID=$(curl http://169.254.169.254/latest/meta-data/ami-id)

echo "Hello world" | sudo tee /var/www/html/index.html
echo "Instance ID: ${INSTANCE_ID}" | sudo tee -a /var/www/html/index.html
echo "Color: ${COLOR}" | sudo tee -a /var/www/html/index.html
echo "AMI ID: ${AMI_ID}" | sudo tee -a /var/www/html/index.html
