package pantry

import "github.com/google/uuid"

type Food struct {
	ID   uuid.UUID
	Name string
}

type Unit string

const (
	Grams      Unit = "g"
	Milliliter Unit = "ml"
	Cups       Unit = "cups"
	Pieces     Unit = "pcs"
	Teaspoon   Unit = "tsp"
)
