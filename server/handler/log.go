package handler

import (
	"errors"
	"net/http"
	"os"

	servertools "github.com/Festivals-App/festivals-server-tools"
	"github.com/Festivals-App/festivals-website/server/config"
	"github.com/rs/zerolog/log"
)

func GetLog(conf *config.Config, w http.ResponseWriter, r *http.Request) {

	l, err := Log("/var/log/festivals-website-node/info.log")
	if err != nil {
		log.Error().Err(err).Msg("Failed to get info log")
		servertools.RespondError(w, http.StatusInternalServerError, http.StatusText(http.StatusInternalServerError))
		return
	}
	servertools.RespondString(w, http.StatusOK, l)
}

func GetTraceLog(conf *config.Config, w http.ResponseWriter, r *http.Request) {

	l, err := Log("/var/log/festivals-website-node/trace.log")
	if err != nil {
		log.Error().Err(err).Msg("Failed to get trace log")
		servertools.RespondError(w, http.StatusInternalServerError, http.StatusText(http.StatusInternalServerError))
		return
	}
	servertools.RespondString(w, http.StatusOK, l)
}

func Log(location string) (string, error) {

	l, err := os.ReadFile(location)
	if err != nil {
		return "", errors.New("Failed to read log file at: '" + location + "' with error: " + err.Error())
	}
	return string(l), nil
}
