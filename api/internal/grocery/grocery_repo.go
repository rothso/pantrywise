package grocery

import (
	"context"
	pantry "pantrywise/internal"

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

	lists := make([]List, 0, len(rows))
	listIndexes := make(map[uuid.UUID]int)
	itemIndexes := make(map[uuid.UUID]int)
	itemRecipes := make(map[uuid.UUID]map[uuid.UUID]struct{})
	for _, row := range rows {
		listIndex, ok := listIndexes[row.ID]

		// Create a new grocery list if it doesn't exist in the map
		if !ok {
			listIndex = len(lists)
			listIndexes[row.ID] = listIndex
			lists = append(lists, List{
				ID:          row.ID,
				HouseholdID: row.HouseholdID,
				Name:        row.Name,
				Items:       make([]Item, 0),
			})
		}

		// Empty grocery list? Send back the list without items
		if row.ItemID == nil {
			continue
		}

		itemIndex, itemExists := itemIndexes[*row.ItemID]
		if !itemExists {
			quantity, err := row.ItemQuantity.Float64Value()
			if err != nil {
				return nil, err
			}
			item := Item{
				ID:       *row.ItemID,
				Quantity: quantity.Float64,
			}
			if row.ItemUnit.Valid {
				item.Unit = pantry.Unit(row.ItemUnit.String)
			}
			if row.ItemFoodID != nil {
				item.Food = &pantry.Food{
					ID:   *row.ItemFoodID,
					Name: row.FoodName.String,
				}
			}
			if row.ItemPurchaseDate.Valid {
				purchaseDate := row.ItemPurchaseDate.Time
				item.PurchaseDate = &purchaseDate
			}
			itemIndex = len(lists[listIndex].Items)
			itemIndexes[*row.ItemID] = itemIndex
			lists[listIndex].Items = append(lists[listIndex].Items, item)
		}

		if row.RecipeID != nil {
			if itemRecipes[*row.ItemID] == nil {
				itemRecipes[*row.ItemID] = make(map[uuid.UUID]struct{})
			}
			if _, exists := itemRecipes[*row.ItemID][*row.RecipeID]; !exists {
				itemRecipes[*row.ItemID][*row.RecipeID] = struct{}{}
				recipe := RelatedRecipe{
					ID:   *row.RecipeID,
					Name: row.RecipeName.String,
				}
				if row.RecipePlannedDate.Valid {
					plannedDate := row.RecipePlannedDate.Time
					recipe.PlannedDate = &plannedDate
				}
				lists[listIndex].Items[itemIndex].Recipes = append(lists[listIndex].Items[itemIndex].Recipes, recipe)
			}
		}
	}
	return lists, nil
}
