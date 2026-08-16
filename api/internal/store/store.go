package store

import (
	"pantrywise/internal"

	"github.com/google/uuid"
)

type Store struct {
	ID          uuid.UUID
	HouseholdID uuid.UUID
	Name        string
}

type Listing struct {
	Item   *pantry.Food
	Store  *Store
	Price  *pantry.Money
	Amount int
	Unit   *pantry.Unit
}
