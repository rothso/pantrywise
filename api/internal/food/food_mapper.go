package food

import (
	pantry "pantrywise/internal"
	groceryv1 "pantrywise/internal/gen/pantrywise/grocery/v1"
)

func foodsToProto(foods []*pantry.Food) *groceryv1.SearchFoodsResponse {
	protoFoods := make([]*groceryv1.Food, 0, len(foods))
	for _, food := range foods {
		protoFoods = append(protoFoods, foodToProto(food))
	}

	return &groceryv1.SearchFoodsResponse{
		Foods: protoFoods,
	}
}

func foodToProto(food *pantry.Food) *groceryv1.Food {
	return &groceryv1.Food{
		FoodId: food.ID.String(),
		Name:   food.Name,
	}
}
