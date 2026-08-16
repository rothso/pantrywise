package main

import (
	"context"
	"log"
	"net/http"
	"pantrywise/internal/config"
	"pantrywise/internal/db"
	"pantrywise/internal/grocery"
	pantry "pantrywise/internal/server"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/joho/godotenv"
)

func main() {
	_ = godotenv.Load()
	cfg := config.Load()

	pool, err := pgxpool.New(context.Background(), cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}
	defer pool.Close()

	err = pool.Ping(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	queries := db.New(pool)

	srv := pantry.NewServer(
		&grocery.Repo{Queries: queries},
	)

	log.Printf("Starting server on %s", cfg.Addr)
	err = http.ListenAndServe(cfg.Addr, srv)
	if err != nil {
		log.Fatal(err)
	}
}
