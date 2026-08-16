package recipe

import (
	"image/color"
	pantry "pantrywise/internal"
	"time"

	"github.com/google/uuid"
)

type Recipe struct {
	ID          uuid.UUID
	HouseholdID uuid.UUID
	Name        string
	Ingredients []Ingredient
	Category    *Category
	PlannedDate *time.Time
}

type Ingredient struct {
	Food        *pantry.Food
	Quantity    float64
	Unit        pantry.Unit
	Preparation Preparation
}

type Preparation string

const (
	Chopped Preparation = "chopped"
	Sliced  Preparation = "sliced"
	Diced   Preparation = "diced"
	Cubed   Preparation = "cubed"
)

type Category struct {
	ID    uuid.UUID
	Name  string
	Color color.RGBA
}
