package main

import (
	"strconv"
	"time"

	"github.com/Festivals-App/festivals-gateway/server/heartbeat"
	"github.com/Festivals-App/festivals-gateway/server/logger"
	"github.com/Festivals-App/festivals-website/server"
	"github.com/Festivals-App/festivals-website/server/config"
	"github.com/rs/zerolog/log"
)

func main() {

	logger.InitializeGlobalLogger("/var/log/festivals-website-node/info.log", true)

	log.Info().Msg("Server startup.")

	conf := config.DefaultConfig()

	log.Info().Msg("Server configuration was initialized.")

	serverInstance := &server.Server{}
	serverInstance.Initialize(conf)

	go serverInstance.Run(conf.ServiceBindAddress + ":" + strconv.Itoa(conf.ServicePort))
	log.Info().Msg("Server did start.")

	go sendNodeHeartbeat(conf)
	go sendSiteHeartbeat(conf)
	log.Info().Msg("Heartbeat routines where started.")

	// wait forever
	// https://stackoverflow.com/questions/36419054/go-projects-main-goroutine-sleep-forever
	select {}
}

func sendNodeHeartbeat(conf *config.Config) {
	for {
		timer := time.After(time.Second * 2)
		<-timer

		var nodeBeat *heartbeat.Heartbeat = &heartbeat.Heartbeat{Service: "festivals-website-node", Host: conf.ServiceBindAddress, Port: conf.ServicePort, Available: true}
		err := heartbeat.SendHeartbeat(conf.LoversEar, conf.ServiceKey, nodeBeat)
		if err != nil {
			log.Error().Err(err).Msg("Failed to send website node heartbeat")
		}
	}
}

func sendSiteHeartbeat(conf *config.Config) {
	for {
		timer := time.After(time.Second * 2)
		<-timer

		var siteBeat *heartbeat.Heartbeat = &heartbeat.Heartbeat{Service: "festivals-website", Host: conf.ServiceBindAddress, Port: 8080, Available: true}
		err := heartbeat.SendHeartbeat(conf.LoversEar, conf.ServiceKey, siteBeat)
		if err != nil {
			log.Error().Err(err).Msg("Failed to send website heartbeat")
		}
	}
}
