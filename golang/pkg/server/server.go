package server

import (
	"encoding/json"
	"net/http"
)

type Server struct {
	Addr string
}

func (s *Server) Home(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(map[string]string{
		"message": "We will rock you!! 🤘",
	})
}

func (s *Server) Start() error {
	mux := http.NewServeMux()
	mux.HandleFunc("/", s.Home)
	srv := &http.Server{Addr: s.Addr, Handler: mux}
	return srv.ListenAndServe()
}
