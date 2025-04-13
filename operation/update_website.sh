#!/bin/bash
#
# install.sh 1.0.0
# 
# (c)2020-2022 Simon Gaus
#

# Test for web server user
#
WEB_USER="www-data"
id -u "$WEB_USER" &>/dev/null;
if [ $? -ne 0 ]; then
  WEB_USER="www"
  if [ $? -ne 0 ]; then
    echo "Failed to find user to run web server. Exiting."
    exit 1
  fi
fi

# Check for NGINX
#
if ! command -v nginx > /dev/null; then
  echo "NGINX is not installed. Exiting."
  exit 1
fi

# Move to working dir
#
mkdir /usr/local/festivals-website/install || { echo "Failed to create working directory. Exiting." ; exit 1; }
cd /usr/local/festivals-website/install || { echo "Failed to access working directory. Exiting." ; exit 1; }

echo "Updating festivals-website"
sleep 1

# Download and extract the latest website release
#
echo "Downloading latest festivals-website files"
sleep 1
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website.tar.gz"
curl -L "$file_url" -o festivals-website.tar.gz
tar -xzvf festivals-website.tar.gz
rm festivals-website.tar.gz

# Install the website files
#
echo "Copying the festivals-website files"
sleep 1
systemctl stop nginx
rm -rf /var/www/festivalsapp.org
mkdir -p /var/www/festivalsapp.org
cp -a ./. /var/www/festivalsapp.org/
chown -R $WEB_USER:$WEB_USER /var/www/festivalsapp.org
chmod -R 755 /var/www/festivalsapp.org
systemctl start nginx

# Delete working dir
#
echo "Cleanup..."
cd /usr/local || exit
rm -R /usr/local/festivals-website/install
sleep 1

echo "Done!"
sleep 1