#!/bin/bash
#
# install.sh 1.0.0
# 
# (c)2020-2021 Simon Gaus
#

# Move to working directory
#
cd /usr/local || exit

# Check for nginx
# 
if ! command -v nginx > /dev/null; then
  echo "NGINX is not installed. Please setup the environment properly before running this script. Exiting."
  exit 1
fi

# Install minify if needed.
#
if ! command -v minify > /dev/null; then
  echo "Installing minify..."
  apt-get install minify -y > /dev/null;
fi

# Install git if needed.
#
if ! command -v git > /dev/null; then
  echo "Installing git..."
  apt-get install git -y > /dev/null;
fi

# Install curl if needed.
#
if ! command -v curl > /dev/null; then
  echo "Installing curl..."
  apt-get install curl -y > /dev/null;
fi

# Use the upgrade script to instal newest website
#
curl -o update.sh https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/update.sh > /dev/null;
chmod +x update.sh
./update.sh
rm update.sh

# Install the nginx config file
#
systemctl stop nginx
echo "Installing the nginx configuration file"
mkdir -p /usr/local/festivals-website
cd /usr/local/festivals-website || exit
curl -o nginx-config https://raw.githubusercontent.com/Festivals-App/festivals-website/master/operation/nginx-config > /dev/null;
cp nginx-config /etc/nginx/sites-available/festivalsapp.org
ln -s /etc/nginx/sites-available/festivalsapp.org /etc/nginx/sites-enabled/
systemctl start nginx

echo "Now you need to setup ssl and you are ready to go."