#!/bin/bash
#
# update.sh 1.0.0
#
#
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