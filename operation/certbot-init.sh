#!/bin/bash

sudo certbot certonly\
  --standalone\
  --http-01-port 8000\
  --deploy-hook 'systemctl reload nginx'\
  --cert-name festivalsapp.org\
  -d festivalsapp.org,www.festivalsapp.org