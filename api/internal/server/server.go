package server

import (
	"net/http"
	"pantrywise/internal/gen/pantrywise/grocery/v1/groceryv1connect"
	"pantrywise/internal/grocery"
	"pantrywise/internal/middleware"

	"connectrpc.com/connect/v2"
	"connectrpc.com/connect/v2/connecthttp"
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

	// gRPC Connect routes
	connectServer := connect.NewServer()
	groceryv1connect.RegisterGroceryServiceHandler(connectServer, grocery.NewService(s.groceryRepo))
	connecthttp.Mount(protected, connectServer)

	s.router.Handle("/", middleware.Authenticate(protected))
}
