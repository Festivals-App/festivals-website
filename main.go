package main

import (
	"net/http"
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

	// Redirect traffic from port 80 to used port
	go http.ListenAndServe(":80", serverInstance.CertManager.HTTPHandler(nil))
	log.Info().Msg("Start redirecting http traffic from port 80 to port " + strconv.Itoa(serverInstance.Config.ServicePort) + " and https")

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

		var nodeBeat *heartbeat.Heartbeat = &heartbeat.Heartbeat{Service: "festivals-website-node", Host: "https://" + conf.ServiceBindHost, Port: conf.ServicePort, Available: true}
		err := heartbeat.SendHeartbeat(conf.LoversEar, conf.ServiceKey, conf.TLSCert, conf.TLSKey, conf.TLSRootCert, nodeBeat)
		if err != nil {
			log.Error().Err(err).Msg("Failed to send website node heartbeat")
		}
	}
}

func sendSiteHeartbeat(conf *config.Config) {
	for {
		timer := time.After(time.Second * 2)
		<-timer

		var siteBeat *heartbeat.Heartbeat = &heartbeat.Heartbeat{Service: "festivals-website", Host: conf.WebsiteProtocol + "://" + conf.WebsiteBindHost, Port: conf.WebsitePort, Available: true}
		err := heartbeat.SendHeartbeat(conf.LoversEar, conf.ServiceKey, conf.TLSCert, conf.TLSKey, conf.TLSRootCert, siteBeat)
		if err != nil {
			log.Error().Err(err).Msg("Failed to send website heartbeat")
		}
	}
}
