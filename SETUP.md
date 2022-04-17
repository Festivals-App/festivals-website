# Development environment for macOS

In order to make contributing to the
[festivals-website](https://github.com/Festivals-App/festivals-website)
as accessible as possible, the website is developed only with free and
open source applications which are available on for every major OS.

## Visual Studio Code

Download and install the [Visual Studio Code](https://code.visualstudio.com/download).
    * Plugin recommendations are managed via [workspace recommendations](https://code.visualstudio.com/docs/editor/extension-marketplace#_recommended-extensions).


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
    root   <path/to/project/folder>/out/current;
```

## Minify (HTML/CSS minifier)

Install [minify](https://github.com/tdewolff/minify)
```
brew install tdewolff/tap/minify
```
