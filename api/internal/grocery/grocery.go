package grocery

import (
	pantry "pantrywise/internal"
	"pantrywise/internal/recipe"
	"pantrywise/internal/store"
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
	Store        *store.Store
	Recipes      []recipe.Recipe
	Quantity     float64
	Unit         *pantry.Unit
	PurchaseDate *time.Time
}
