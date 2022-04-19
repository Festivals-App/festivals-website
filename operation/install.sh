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
mkdir -p /usr/local/festivals-website/install || { echo "Failed to create working directory. Exiting." ; exit 1; }
cd /usr/local/festivals-website/install || { echo "Failed to access working directory. Exiting." ; exit 1; }

echo "Installing festivals-website"
sleep 1

# Download and extract the latest website release
#
echo "Downloading latest festivals-website release"
sleep 1
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website.tar.gz"
curl -L "$file_url" -o festivals-website.tar.gz
tar -xzf festivals-website.tar.gz
rm festivals-website.tar.gz

# Install the nginx config file
#
mkdir -p /etc/nginx/sites-available || { echo "Failed to create sites-available directory. Exiting." ; exit 1; }
mv nginx-config /etc/nginx/sites-available/festivalsapp.org
ln -s /etc/nginx/sites-available/festivalsapp.org /etc/nginx/sites-enabled/
echo "Installed the nginx configuration file"
sleep 1

## Prepare website update workflow
#
mv update_website.sh /usr/local/festivals-website/update.sh
cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website/update.sh" >> /tmp/sudoers.bak

# Check syntax of the backup file to make sure it is correct.
visudo -cf /tmp/sudoers.bak
if [ $? -eq 0 ]; then
  # Replace the sudoers file with the new only if syntax is correct.
  sudo cp /tmp/sudoers.bak /etc/sudoers
else
  echo "Could not modify /etc/sudoers file. Please do this manually." ; exit 1;
fi

# Install the website files
#
mkdir -p /var/www/festivalsapp.org
cp -a ./. /var/www/festivalsapp.org/
chown -R $WEB_USER:$WEB_USER /var/www/festivalsapp.org
chmod -R 755 /var/www/festivalsapp.org
echo "Moved website files to '/var/www/festivalsapp.org/'"
sleep 1

# Move to working dir
#
mkdir -p /usr/local/festivals-website-node/install || { echo "Failed to create working directory. Exiting." ; exit 1; }
cd /usr/local/festivals-website-node/install || { echo "Failed to access working directory. Exiting." ; exit 1; }

echo "Installing festivals-website-node using port 48155."
sleep 1

# Get system os
#
if [ "$(uname -s)" = "Darwin" ]; then
  os="darwin"
elif [ "$(uname -s)" = "Linux" ]; then
  os="linux"
else
  echo "System is not Darwin or Linux. Exiting."
  exit 1
fi

# Get systems cpu architecture
#
if [ "$(uname -m)" = "x86_64" ]; then
  arch="amd64"
elif [ "$(uname -m)" = "arm64" ]; then
  arch="arm64"
else
  echo "System is not x86_64 or arm64. Exiting."
  exit 1
fi

# Build url to latest binary for the given system
#
file_url="https://github.com/Festivals-App/festivals-website/releases/latest/download/festivals-website-node-$os-$arch.tar.gz"
echo "The system is $os on $arch."
sleep 1

# Install festivals-website-node to /usr/local/bin/festivals-website-node. TODO: Maybe just link to /usr/local/bin?
#
echo "Downloading newest festivals-website-node binary release..."
curl -L "$file_url" -o festivals-website-node.tar.gz
tar -xf festivals-website-node.tar.gz
mv festivals-website-node /usr/local/bin/festivals-website-node || { echo "Failed to install festivals-website-node binary. Exiting." ; exit 1; }
echo "Installed the festivals-website-node binary to '/usr/local/bin/festivals-website-node'."
sleep 1

## Install server config file
mv config_template.toml /etc/festivals-website-node.conf
echo "Moved default festivals-website-node config to '/etc/festivals-website-node.conf'."
sleep 1

## Prepare log directory
mkdir /var/log/festivals-website-node || { echo "Failed to create log directory. Exiting." ; exit 1; }
chown "$WEB_USER":"$WEB_USER" /var/log/festivals-website-node
echo "Create log directory at '/var/log/festivals-website-node'."

## Prepare node update workflow
#
mv update_node.sh /usr/local/festivals-website-node/update.sh
cp /etc/sudoers /tmp/sudoers.bak
echo "$WEB_USER ALL = (ALL) NOPASSWD: /usr/local/festivals-website-node/update.sh" >> /tmp/sudoers.bak

# Check syntax of the backup file to make sure it is correct.
visudo -cf /tmp/sudoers.bak
if [ $? -eq 0 ]; then
  # Replace the sudoers file with the new only if syntax is correct.
  sudo cp /tmp/sudoers.bak /etc/sudoers
else
  echo "Could not modify /etc/sudoers file. Please do this manually." ; exit 1;
fi

# Enable and configure the firewall.
#
if command -v ufw > /dev/null; then

  ufw allow 48155/tcp >/dev/null
  echo "Added festivals-server to ufw using port 48155."
  sleep 1

elif ! [ "$(uname -s)" = "Darwin" ]; then
  echo "No firewall detected and not on macOS. Exiting."
  exit 1
fi

# Install systemd service
#
if command -v service > /dev/null; then

  if ! [ -f "/etc/systemd/system/festivals-website-node.service" ]; then
    mv service_template.service /etc/systemd/system/festivals-website-node.service
    echo "Created systemd service."
    sleep 1
  fi

  systemctl enable festivals-website-node > /dev/null
  echo "Enabled systemd service."
  sleep 1

elif ! [ "$(uname -s)" = "Darwin" ]; then
  echo "Systemd is missing and not on macOS. Exiting."
  exit 1
fi

# Cleanup installation
#
echo "Cleanup..."
cd /usr/local/festivals-website || exit
rm -R /usr/local/festivals-website/install
rm -R /usr/local/festivals-website-node/install
sleep 1

echo "Done!"
sleep 1

echo "You can start nginx manually by running 'systemctl start nginx' after you updated the configuration file at '/etc/festivals-website-node.conf'"
sleep 1