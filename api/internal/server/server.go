package server

import (
	"net/http"
	"pantrywise/internal/grocery"
	"pantrywise/internal/middleware"
)

type Server struct {
	router      *http.ServeMux
	groceryRepo *grocery.Repo
}

func NewServer(groceryRepo *grocery.Repo) *Server {
	s := &Server{
		router:      http.NewServeMux(),
		groceryRepo: groceryRepo,
	}
	s.routes()
	return s
}

func (s *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.router.ServeHTTP(w, r)
}

func (s *Server) routes() {
	protected := http.NewServeMux()
	protected.HandleFunc("GET /grocery", grocery.HandleList(s.groceryRepo))

	s.router.Handle("/", middleware.Authenticate(protected))
}
