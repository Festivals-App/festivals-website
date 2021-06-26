#!/bin/bash
#
# update.sh 1.0.0
#
# Enables the firewall, installs the newest go and the festivals-server and starts it as a service.
#
# (c)2020-2021 Simon Gaus
#

# Move to working directory
#
cd /usr/local || exit

# Install minify if needed.
#
if ! command -v go > /dev/null; then
  echo "Installing minify..."
  apt-get install -y minify
fi

# Install git if needed.
#
if ! command -v git > /dev/null; then
  echo "Installing git..."
  apt-get install git -y > /dev/null;
fi

# Compiling and installing festivals-website to /var/www/festivalsapp.org/html
#
echo "Downloading current festivals-website..."
yes | sudo git clone https://github.com/Festivals-App/festivals-website.git /usr/local/festivals-website > /dev/null;
