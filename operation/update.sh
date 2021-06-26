#!/bin/bash
#
# update.sh 1.0.0
#
# Enables the firewall, installs the newest go and the festivals-server and starts it as a service.
#
# (c)2020-2021 Simon Gaus
#

# Check for minify
# 
if ! command -v minify > /dev/null; then
  echo "Minify is not installed. Exiting."
  exit 1
fi

# Check for find
# 
if ! command -v find > /dev/null; then
  echo "Find is not installed. Exiting."
  exit 1
fi