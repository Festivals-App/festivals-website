package server

import (
	"crypto/tls"
	"net/http"

	"github.com/Festivals-App/festivals-gateway/server/logger"
	"github.com/Festivals-App/festivals-identity-server/authentication"
	"github.com/Festivals-App/festivals-identity-server/festivalspki"
	"github.com/Festivals-App/festivals-website/server/config"
	"github.com/Festivals-App/festivals-website/server/handler"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/rs/zerolog/log"
	"golang.org/x/crypto/acme/autocert"
)

// Server has router and configuration
type Server struct {
	Router      *chi.Mux
	Config      *config.Config
	CertManager *autocert.Manager
	TLSConfig   *tls.Config
}

// Initialize the server with predefined configuration
func (s *Server) Initialize(config *config.Config) {

	s.Router = chi.NewRouter()
	s.Config = config

	s.setTLSHandling()
	s.setMiddleware()
	s.setRoutes()
}

func (s *Server) setTLSHandling() {

	base := s.Config.ServiceBindAddress
	hosts := []string{base}

	certManager := autocert.Manager{
		Prompt:     autocert.AcceptTOS,
		HostPolicy: autocert.HostWhitelist(hosts...),
		Cache:      autocert.DirCache("/etc/letsencrypt/live/" + base),
	}

	tlsConfig := certManager.TLSConfig()
	tlsConfig.GetCertificate = festivalspki.LoadServerCertificates(s.Config.TLSCert, s.Config.TLSKey, s.Config.TLSRootCert, &certManager)
	s.CertManager = &certManager
	s.TLSConfig = tlsConfig
}

func (s *Server) setMiddleware() {
	// tell the ruter which middleware to use
	s.Router.Use(
		// used to log the request to the console | development
		logger.Middleware(logger.TraceLogger("/var/log/festivals-website-node/trace.log")),
		// tries to recover after panics
		middleware.Recoverer,
	)
}

// setRouters sets the all required routers
func (s *Server) setRoutes() {

	s.Router.Get("/version", s.handleRequestWithoutAuthentication(handler.GetVersion))
	s.Router.Get("/info", s.handleRequestWithoutAuthentication(handler.GetInfo))
	s.Router.Get("/health", s.handleRequestWithoutAuthentication(handler.GetHealth))

	s.Router.Post("/update/website", s.handleAdminRequest(handler.MakeWebsiteUpdate))
	s.Router.Post("/update", s.handleAdminRequest(handler.MakeUpdate))
	s.Router.Get("/log", s.handleAdminRequest(handler.GetLog))
	s.Router.Get("/log/trace", s.handleAdminRequest(handler.GetTraceLog))
}

func (s *Server) Run(host string) {

	server := http.Server{
		Addr:      host,
		Handler:   s.Router,
		TLSConfig: s.TLSConfig,
	}

	specifiedInTLSConfig := ""
	if err := server.ListenAndServeTLS(specifiedInTLSConfig, specifiedInTLSConfig); err != nil {
		log.Fatal().Err(err).Str("type", "server").Msg("Failed to run server")
	}
}

// function prototype to inject config instance in handleRequest()
type RequestHandlerFunction func(config *config.Config, w http.ResponseWriter, r *http.Request)

/*
func (s *Server) handleRequest(handler RequestHandlerFunction) http.HandlerFunc {

	return authentication.IsEntitled(s.Config.APIKeys, func(w http.ResponseWriter, r *http.Request) {
		handler(s.Config, w, r)
	})
}
*/

func (s *Server) handleAdminRequest(requestHandler RequestHandlerFunction) http.HandlerFunc {

	return authentication.IsEntitled(s.Config.AdminKeys, func(w http.ResponseWriter, r *http.Request) {
		requestHandler(s.Config, w, r)
	})
}

// inject Config in handler functions
func (s *Server) handleRequestWithoutAuthentication(requestHandler RequestHandlerFunction) http.HandlerFunc {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		requestHandler(s.Config, w, r)
	})
}
