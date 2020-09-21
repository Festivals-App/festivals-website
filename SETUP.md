# Development environment for macOS

In order to make contributing to the
[festivals-website](https://github.com/Festivals-App/festivals-website)
as accessible as possible, the website is developed only with free and
open source applications which are available on for every major OS.

## Atom Editor

Download and install the [Atom Editor](https://atom.io/).

Installed Atom Packets:
  * language-applescript
  * build-osa
    dependencies: build, busy-signal
  * pp-markdown


## NGINX webserver

```
brew install nginx
nginx
nginx -s stop

```

Edit */usr/local/etc/nginx/nginx.conf* and change

```
location / {
    root   html;
```
to
```
location / {
    root   <path/to/project/folder>/build/current;
```

## Minify (HTML/CSS minifier)

Install [minify](https://github.com/tdewolff/minify) to
```
brew install tdewolff/tap/minify
```
