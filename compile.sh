#!/bin/bash
#
# compile.sh 1.0.0
#
# All necessary files are in the ./source folder waiting to get compiled by this script.
# It is minifying and merging those files and is outputting the result to a folder that is called "out". 
# This folder now contains a new folder with the current timestamp as its name and a folder called "current". 
# The "current" folder will always contain the newest compiled files, and can be used to check the latest changes 
# to the source files using a browser.
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

# Set and create base paths
# 
current_time="$(date +"%Y%m%d-%H-%M-%S")"
source_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )/source"
build_path="out/$current_time"
current_build_path="out/current"

mkdir -p "$build_path"
cp "$source_path"/* "$build_path" 2>/dev/null

# Handle css compiling
# 
css_source_path="$source_path/css"
css_build_path="$build_path/css"
temp_css_file="$build_path/css/temp_css_file.css"
min_css_file="$build_path/css/style.min.css"

mkdir -p "$css_build_path"
find "$css_source_path" -name '*.css' -exec cat {} + > "$temp_css_file"
minify -o "$min_css_file" "$temp_css_file"
rm "$temp_css_file"

# Handle the php, localizations and images
# 
php_source_path="$source_path/php"
en_source_path="$source_path/en"
images_source_path="$source_path/images"

cp -r "$php_source_path" "$build_path"
cp -r "$en_source_path" "$build_path"
cp -r "$images_source_path" "$build_path"

# Handle apple-app-site-association file
# 
site_association_source_path="$source_path/apple-app-site-association"
site_association_folder="$build_path/.well-known"
site_association_build_path="$site_association_folder/apple-app-site-association"
mkdir -p "$site_association_folder"
cp "$site_association_source_path" "$site_association_build_path"

# Cleanup
# 
rm -rf "$current_build_path"
cp -r "$build_path" "$current_build_path"

echo "Done compiling festivalsapp.org source files."