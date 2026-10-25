package recipe

import (
	pantry "pantrywise/internal"
	"time"

	"github.com/google/uuid"
)

type Recipe struct {
	ID          uuid.UUID
	HouseholdID uuid.UUID
	Name        string
	Ingredients []Ingredient
	PlannedDate *time.Time
}

type Ingredient struct {
	Food     *pantry.Food
	Quantity float64
	Unit     pantry.Unit
}
