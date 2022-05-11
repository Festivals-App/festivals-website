#!/bin/bash
#
# update.sh 1.0.0
#
# Updates the festivals-website-node and restarts it.
#
# (c)2020-2022 Simon Gaus
#

# Move to working dir
#
mkdir /usr/local/festivals-website-node/install || { echo "Failed to create working directory. Exiting." ; exit 1; }
cd /usr/local/festivals-website-node/install || { echo "Failed to access working directory. Exiting." ; exit 1; }

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

# Removing unused files
#
echo "Cleanup..."
cd /usr/local/festivals-website-node
rm -r /usr/local/festivals-website-node/install
sleep 1

# Restart the festivals-website-node
#
systemctl restart festivals-website-node
echo "Restarted the festivals-website-node"
sleep 1

echo "Done!"
sleep 1