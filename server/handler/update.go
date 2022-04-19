package handler

import (
	"net/http"

	"github.com/Festivals-App/festivals-gateway/server/update"
	"github.com/Festivals-App/festivals-website/server/config"
	"github.com/Festivals-App/festivals-website/server/status"
	"github.com/rs/zerolog/log"
)

func MakeUpdate(conf *config.Config, w http.ResponseWriter, _ *http.Request) {

	newVersion, err := update.RunUpdate(status.ServerVersion, "https://github.com/Festivals-App/festivals-website/releases/latest", "/usr/local/festivals-website-node/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		respondError(w, http.StatusInternalServerError, "Failed to update")
		return
	}

	respondString(w, http.StatusAccepted, newVersion)
}

func MakeWebsiteUpdate(conf *config.Config, w http.ResponseWriter, _ *http.Request) {

	newVersion, err := update.RunUpdate(status.ServerVersion, "<alwaysupdate>", "/usr/local/festivals-website/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		respondError(w, http.StatusInternalServerError, "Failed to update")
		return
	}

	respondString(w, http.StatusAccepted, newVersion)
}
