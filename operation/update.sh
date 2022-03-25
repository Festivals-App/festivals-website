#!/bin/bash
#
# install.sh 1.0.0
# 
# (c)2020-2022 Simon Gaus
#

# Check for NGINX
#
if ! command -v nginx > /dev/null; then
  echo "NGINX is not installed. Exiting."
  exit 1
fi

# Move to working dir
#
mkdir /usr/local/festivals-website || { echo "Failed to create working directory. Exiting." ; exit 1; }
cd /usr/local/festivals-website || { echo "Failed to access working directory. Exiting." ; exit 1; }

echo "Installing festivals-website"
sleep 1

# Download and extract the latest website release
#
echo "Downloading latest festivals-website files"
sleep 1
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website.tar.gz"
curl -L "$file_url" -o festivals-website.tar.gz
tar -xzvf festivals-website.tar.gz
rm festivals-website.tar.gz
rm nginx-config

# Stop nginx if running
#
echo "Stopping NGINX"
sleep 1
systemctl stop nginx

# Install the website files
#
echo "Copying the festivals-website files"
sleep 1
rm -rf /var/www/festivalsapp.org
mkdir -p /var/www/festivalsapp.org
cp -a ./. /var/www/festivalsapp.org/
chown -R $USER:$USER /var/www/festivalsapp.org
chmod -R 755 /var/www/festivalsapp.org

# Start nginx
#
echo "Starting NGINX"
sleep 1
systemctl start nginx

# Delete working dir
#
echo "Cleanup..."
cd /usr/local || exit
rm -R /usr/local/festivals-website
sleep 1

echo "Now you need to setup ssl and you are ready to go."
sleep 1