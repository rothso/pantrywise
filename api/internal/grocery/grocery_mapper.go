package grocery

import (
	groceryv1 "pantrywise/internal/gen/pantrywise/grocery/v1"

	"google.golang.org/protobuf/types/known/timestamppb"
)

func groceryListsToProto(lists []List) *groceryv1.ListGroceryListsResponse {
	protoLists := make([]*groceryv1.GroceryList, 0, len(lists))
	for _, list := range lists {
		protoLists = append(protoLists, groceryListToProto(list))
	}

	return &groceryv1.ListGroceryListsResponse{
		GroceryLists: protoLists,
	}
}

func groceryListToProto(list List) *groceryv1.GroceryList {
	protoItems := make([]*groceryv1.GroceryListItem, 0, len(list.Items))
	for _, item := range list.Items {
		protoItem := &groceryv1.GroceryListItem{
			ItemId:   item.ID.String(),
			Quantity: item.Quantity,
			Unit:     string(item.Unit),
		}
		if item.Food != nil {
			protoItem.FoodId = item.Food.ID.String()
			protoItem.FoodName = item.Food.Name
		}
		if item.PurchaseDate != nil {
			protoItem.PurchaseDate = timestamppb.New(*item.PurchaseDate)
		}
		protoRecipes := make([]*groceryv1.GroceryListRelatedRecipe, 0, len(item.Recipes))
		for _, relatedRecipe := range item.Recipes {
			protoRecipe := &groceryv1.GroceryListRelatedRecipe{
				RecipeId: relatedRecipe.ID.String(),
				Name:     relatedRecipe.Name,
			}
			if relatedRecipe.PlannedDate != nil {
				protoRecipe.PlannedDate = timestamppb.New(*relatedRecipe.PlannedDate)
			}
			protoRecipes = append(protoRecipes, protoRecipe)
		}
		protoItem.RelatedRecipes = protoRecipes
		protoItems = append(protoItems, protoItem)
	}

	return &groceryv1.GroceryList{
		ListId: list.ID.String(),
		Name:   list.Name,
		Items:  protoItems,
	}
}
