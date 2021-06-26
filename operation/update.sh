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

# Check for minify
# 
if ! command -v minify > /dev/null; then
  echo "MINIFY is not installed. Please run the install script first. Exiting."
  exit 1
fi

# Check for git
# 
if ! command -v git > /dev/null; then
  echo "GIT is not installed. Please run the install script first. Exiting."
  exit 1
fi

# Compiling and installing festivals-website to /var/www/festivalsapp.org
#
echo "Downloading current festivals-website..."
yes | sudo git clone https://github.com/Festivals-App/festivals-website.git /usr/local/festivals-website > /dev/null;
cd /usr/local/festivals-website
./compile.sh

echo "Installing current festivals-website..."
systemctl stop nginx
rm -rf /var/www/festivalsapp.org
chown -R $USER:$USER /var/www/festivalsapp.org
chmod -R 755 /var/www/festivalsapp.org

# Cleanup
cd /usr/local || exit
rm -rf /usr/local/festivals-website
systemctl start nginx