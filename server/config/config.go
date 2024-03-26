package config

import (
	"os"

	servertools "github.com/Festivals-App/festivals-server-tools"
	"github.com/pelletier/go-toml"
	"github.com/rs/zerolog/log"
)

type Config struct {
	ServiceBindAddress string
	ServiceBindHost    string
	ServicePort        int
	ServiceKey         string
	TLSRootCert        string
	TLSCert            string
	TLSKey             string
	LoversEar          string
	Interval           int
	IdentityEndpoint   string
	WebsiteBindHost    string
	WebsitePort        int
	WebsiteProtocol    string
}

func DefaultConfig() *Config {

	// first we try to parse the config at the global configuration path
	if servertools.FileExists("/etc/festivals-website-node.conf") {
		config := ParseConfig("/etc/festivals-website-node.conf")
		if config != nil {
			return config
		}
	}

	// if there is no global configuration check the current folder for the template config file
	// this is mostly so the application will run in development environment
	path, err := os.Getwd()
	if err != nil {
		log.Fatal().Msg("server initialize: could not read default config file with error:" + err.Error())
	}
	path = path + "/config_template.toml"
	return ParseConfig(path)
}

func ParseConfig(cfgFile string) *Config {

	content, err := toml.LoadFile(cfgFile)
	if err != nil {
		log.Fatal().Msg("server initialize: could not read config file at '" + cfgFile + "' with error: " + err.Error())
	}

	serviceBindAdress := content.Get("service.bind-address").(string)
	serviceBindHost := content.Get("service.bind-host").(string)
	servicePort := content.Get("service.port").(int64)
	serviceKey := content.Get("service.key").(string)

	tlsrootcert := content.Get("tls.festivaslapp-root-ca").(string)
	tlscert := content.Get("tls.cert").(string)
	tlskey := content.Get("tls.key").(string)

	loversear := content.Get("heartbeat.endpoint").(string)
	interval := content.Get("heartbeat.interval").(int64)

	identity := content.Get("authentication.endpoint").(string)

	websiteBindHost := content.Get("website.bind-host").(string)
	websitePort := content.Get("website.port").(int64)
	websiteProtocol := content.Get("website.protocol").(string)

	return &Config{
		ServiceBindAddress: serviceBindAdress,
		ServiceBindHost:    serviceBindHost,
		ServicePort:        int(servicePort),
		ServiceKey:         serviceKey,
		TLSRootCert:        tlsrootcert,
		TLSCert:            tlscert,
		TLSKey:             tlskey,
		LoversEar:          loversear,
		Interval:           int(interval),
		IdentityEndpoint:   identity,
		WebsiteBindHost:    websiteBindHost,
		WebsitePort:        int(websitePort),
		WebsiteProtocol:    websiteProtocol,
	}
}
