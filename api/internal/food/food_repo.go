package food

import (
	"context"
	"strings"

	pantry "pantrywise/internal"
	"pantrywise/internal/db"

	"github.com/google/uuid"
)

type Repo struct {
	Queries *db.Queries
}

func (r *Repo) SearchFoods(ctx context.Context, householdID uuid.UUID, query string) ([]*pantry.Food, error) {
	var (
		rows []db.SearchFoodsRow
		err  error
	)

	if strings.TrimSpace(query) == "" {
		initialRows, queryErr := r.Queries.GetInitialSearchFoods(ctx, householdID)
		if queryErr != nil {
			return nil, queryErr
		}

		foods := make([]*pantry.Food, 0, len(initialRows))
		for _, row := range initialRows {
			foods = append(foods, &pantry.Food{ID: row.ID, Name: row.Name})
		}
		return foods, nil
	}

	rows, err = r.Queries.SearchFoods(ctx, db.SearchFoodsParams{
		HouseholdID: householdID,
		Query:       query,
	})
	if err != nil {
		return nil, err
	}

	foods := make([]*pantry.Food, 0, len(rows))
	for _, row := range rows {
		foods = append(foods, &pantry.Food{ID: row.ID, Name: row.Name})
	}
	return foods, nil
}
