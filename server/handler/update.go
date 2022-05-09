package handler

import (
	"io/ioutil"
	"net/http"
	"strings"

	"github.com/Festivals-App/festivals-gateway/server/update"
	"github.com/Festivals-App/festivals-website/server/config"
	"github.com/Festivals-App/festivals-website/server/status"
	"github.com/rs/zerolog/log"
)

func MakeUpdate(conf *config.Config, w http.ResponseWriter, _ *http.Request) {

	newVersion, err := update.RunUpdate(status.ServerVersion, "Festivals-App", "festivals-website", "/usr/local/festivals-website-node/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		respondError(w, http.StatusInternalServerError, "Failed to update")
		return
	}

	respondString(w, http.StatusAccepted, newVersion)
}

func MakeWebsiteUpdate(conf *config.Config, w http.ResponseWriter, _ *http.Request) {

	content, err := ioutil.ReadFile("/var/www/festivalsapp.org/version")
	if err != nil {
		log.Error().Err(err).Msg("Failed to read current version from file")
		respondError(w, http.StatusInternalServerError, "Failed to update")
		return
	}

	newVersion, err := update.RunUpdate(strings.TrimSpace(string(content)), "Festivals-App", "festivals-website", "/usr/local/festivals-website/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		respondError(w, http.StatusInternalServerError, "Failed to update")
		return
	}

	respondString(w, http.StatusAccepted, newVersion)
}
