##

install nginx (homebrew!)
  -> sudo nginx
  -> sudo nginx -s stop
  -> sudo nginx -s reload

in /usr/local/etc/nginx/nginx.conf
  -> add/edit "user simon staff;"

in /usr/local/etc/nginx/sites-available/default
  -> set root to project folder/build/current

install minify
  -> brew install tdewolff/tap/minify
