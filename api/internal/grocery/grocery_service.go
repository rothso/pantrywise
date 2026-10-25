package grocery

import (
	"context"
	groceryv1 "pantrywise/internal/gen/pantrywise/grocery/v1"
	"pantrywise/internal/gen/pantrywise/grocery/v1/groceryv1connect"
	"pantrywise/internal/middleware"

	"connectrpc.com/connect/v2"
)

type Service struct {
	groceryv1connect.UnimplementedGroceryServiceHandler
	repo *Repo
}

func NewService(repo *Repo) *Service {
	return &Service{repo: repo}
}

func (s *Service) ListGroceryLists(ctx context.Context, _ *groceryv1.ListGroceryListsRequest) (*groceryv1.ListGroceryListsResponse, error) {
	householdID, ok := middleware.HouseholdID(ctx)
	if !ok {
		return nil, connect.NewError(connect.CodeUnauthenticated, "household ID not found in context")
	}

	lists, err := s.repo.GetGroceryLists(ctx, householdID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, "failed to retrieve grocery lists")
	}

	response := groceryListsToProto(lists)
	return response, nil
}
