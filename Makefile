# Makefile for festivals-website-node

VERSION=development
DATE=$(shell date +"%d-%m-%Y-%H-%M")
REF=refs/tags/development
export

build:
	./compile.sh
	go build -v -ldflags="-X 'github.com/Festivals-App/festivals-website/server/status.ServerVersion=$(VERSION)' -X 'github.com/Festivals-App/festivals-website/server/status.BuildTime=$(DATE)' -X 'github.com/Festivals-App/festivals-website/server/status.GitRef=$(REF)'" -o festivals-website-node main.go

install:
	cp festivals-website-node /usr/local/bin/festivals-website-node
	cp config_template.toml /etc/festivals-website-node.conf
	cp operation/service_template.service /etc/systemd/system/festivals-website-node.service

update:
	systemctl stop festivals-website-node
	cp festivals-website-node /usr/local/bin/festivals-website-node
	systemctl start festivals-website-node

uninstall:
	systemctl stop festivals-website-node
	rm /usr/local/bin/festivals-website-node
	rm /etc/festivals-website-node.conf
	rm /etc/systemd/system/festivals-website-node.service

run:
	./festivals-website-node --debug

stop:
	killall festivals-website-node

clean:
	rm -r festivals-website-node