package handler

import (
	"net/http"
	"os"
	"strings"

	token "github.com/Festivals-App/festivals-identity-server/jwt"
	servertools "github.com/Festivals-App/festivals-server-tools"
	"github.com/Festivals-App/festivals-website/server/status"
	"github.com/rs/zerolog/log"
)

func MakeUpdate(claims *token.UserClaims, w http.ResponseWriter, _ *http.Request) {

	if claims.UserRole != token.ADMIN {
		log.Error().Msg("User is not authorized to update service.")
		servertools.UnauthorizedResponse(w)
		return
	}

	newVersion, err := servertools.RunUpdate(status.ServerVersion, "Festivals-App", "festivals-website", "/usr/local/festivals-website-node/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		servertools.RespondError(w, http.StatusInternalServerError, http.StatusText(http.StatusInternalServerError))
		return
	}

	servertools.RespondString(w, http.StatusAccepted, newVersion)
}

func MakeWebsiteUpdate(w http.ResponseWriter, _ *http.Request) {

	content, err := os.ReadFile("/var/www/festivalsapp.org/version")
	if err != nil {
		log.Error().Err(err).Msg("Failed to read current version from file")
		servertools.RespondError(w, http.StatusInternalServerError, http.StatusText(http.StatusInternalServerError))
		return
	}

	newVersion, err := servertools.RunUpdate(strings.TrimSpace(string(content)), "Festivals-App", "festivals-website", "/usr/local/festivals-website/update.sh")
	if err != nil {
		log.Error().Err(err).Msg("Failed to update")
		servertools.RespondError(w, http.StatusInternalServerError, http.StatusText(http.StatusInternalServerError))
		return
	}

	servertools.RespondString(w, http.StatusAccepted, newVersion)
}
