package config

import (
	"log"
	"os"
)

type Config struct {
	Addr        string
	DatabaseURL string
}

func Load() Config {
	cfg := Config{
		Addr:        getEnv("ADDR", ":8080"),
		DatabaseURL: getRequiredEnv("DATABASE_URL"),
	}
	return cfg
}

func getEnv(key, fallback string) string {
	if val, ok := os.LookupEnv(key); ok {
		return val
	}
	return fallback
}

func getRequiredEnv(key string) string {
	val, ok := os.LookupEnv(key)
	if !ok {
		log.Fatalf("Missing required env: %q", key)
	}
	return val
}
