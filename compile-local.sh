#!/bin/bash

current_time="$(date +"%Y%m%d-%H-%M-%S")"
source_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )/source"
build_path="build/$current_time"
current_build_path="build/current"

mkdir -p "$build_path"
cp "$source_path"/* "$build_path"



css_source_path="$source_path/css"
css_build_path="$build_path/css"
temp_css_file="$build_path/css/temp_css_file.css"
min_css_file="$build_path/css/style.min.css"

mkdir -p "$css_build_path"
find "$css_source_path" -name '*.css' -exec cat {} + > "$temp_css_file"
minify -o "$min_css_file" "$temp_css_file"
rm "$temp_css_file"




php_source_path="$source_path/php"
en_source_path="$source_path/en"
images_source_path="$source_path/images"

cp -r "$php_source_path" "$build_path"
cp -r "$en_source_path" "$build_path"
cp -r "$images_source_path" "$build_path"




rm -rf "$current_build_path"
mkdir -p "$current_build_path"
cp -r "$build_path"/* "$current_build_path"