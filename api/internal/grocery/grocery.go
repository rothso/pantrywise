package grocery

import (
	pantry "pantrywise/internal"
	"time"

	"github.com/google/uuid"
)

type List struct {
	ID          uuid.UUID
	HouseholdID uuid.UUID
	Name        string
	Items       []Item
}

type Item struct {
	ID           uuid.UUID
	Food         *pantry.Food
	Recipes      []RelatedRecipe
	Quantity     float64
	Unit         pantry.Unit
	PurchaseDate *time.Time
}

type RelatedRecipe struct {
	ID          uuid.UUID
	Name        string
	PlannedDate *time.Time
}
