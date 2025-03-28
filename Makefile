# Makefile for festivals-website-node

VERSION=development
DATE=$(shell date +"%d-%m-%Y-%H-%M")
REF=refs/tags/development
DEV_PATH_MAC=$(shell echo ~/Library/Containers/org.festivalsapp.project)
export

build:
	./compile.sh
	go build -ldflags="-X 'github.com/Festivals-App/festivals-website/server/status.ServerVersion=$(VERSION)' -X 'github.com/Festivals-App/festivals-website/server/status.BuildTime=$(DATE)' -X 'github.com/Festivals-App/festivals-website/server/status.GitRef=$(REF)'" -o festivals-website-node main.go

install:
	mkdir -p $(DEV_PATH_MAC)/usr/local/bin
	mkdir -p $(DEV_PATH_MAC)/etc
	mkdir -p $(DEV_PATH_MAC)/var/log
	mkdir -p $(DEV_PATH_MAC)/usr/local/festivals-website-node

	cp operation/local/ca.crt  $(DEV_PATH_MAC)/usr/local/festivals-website-node/ca.crt
	cp operation/local/server.crt  $(DEV_PATH_MAC)/usr/local/festivals-website-node/server.crt
	cp operation/local/server.key  $(DEV_PATH_MAC)/usr/local/festivals-website-node/server.key
	cp festivals-website-node $(DEV_PATH_MAC)/usr/local/bin/festivals-website-node
	chmod +x $(DEV_PATH_MAC)/usr/local/bin/festivals-website-node
	cp operation/local/config_template_dev.toml $(DEV_PATH_MAC)/etc/festivals-website-node.conf

run:
	./festivals-website-node --container="$(DEV_PATH_MAC)"

run-env:
	$(DEV_PATH_MAC)/usr/local/bin/festivals-identity-server --container="$(DEV_PATH_MAC)" &
	sleep 1
	$(DEV_PATH_MAC)/usr/local/bin/festivals-gateway --container="$(DEV_PATH_MAC)" &

stop-env:
	killall festivals-gateway
	killall festivals-identity-server

clean:
	rm -r festivals-website-node