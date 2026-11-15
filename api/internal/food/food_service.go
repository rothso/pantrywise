package food

import (
	"context"
	groceryv1 "pantrywise/internal/gen/pantrywise/grocery/v1"
	"pantrywise/internal/gen/pantrywise/grocery/v1/groceryv1connect"
	"pantrywise/internal/middleware"

	"connectrpc.com/connect/v2"
)

type Service struct {
	groceryv1connect.UnimplementedFoodServiceHandler
	repo *Repo
}

func NewService(repo *Repo) *Service {
	return &Service{repo: repo}
}

func (s *Service) SearchFoods(ctx context.Context, request *groceryv1.SearchFoodsRequest) (*groceryv1.SearchFoodsResponse, error) {
	householdID, ok := middleware.HouseholdID(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, "household ID not found in context")
	}

	foods, err := s.repo.SearchFoods(ctx, householdID, request.GetQuery())
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, "failed to search foods")
	}

	response := foodsToProto(foods)
	return response, nil
}
