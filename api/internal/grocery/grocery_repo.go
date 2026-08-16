package grocery

import (
	"context"

	"pantrywise/internal/db"

	"github.com/google/uuid"
)

type Repo struct {
	Queries *db.Queries
}

func (r *Repo) GetGroceryLists(ctx context.Context, householdID uuid.UUID) ([]List, error) {
	rows, err := r.Queries.GetGroceryLists(ctx, householdID)
	if err != nil {
		return nil, err
	}

	lists := make([]List, len(rows))
	for i, row := range rows {
		lists[i] = List{
			ID:          row.ID,
			HouseholdID: householdID,
			Name:        row.Name,
			Items:       []Item{}, // TODO: fetch items separately
		}
	}
	return lists, nil
}
