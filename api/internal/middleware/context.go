package middleware

import (
	"context"

	"github.com/google/uuid"
)

type contextKey string

const (
	HouseholdIDKey contextKey = "householdID"
	UserIDKey      contextKey = "userID"
)

func HouseholdID(ctx context.Context) (uuid.UUID, bool) {
	id, ok := ctx.Value(HouseholdIDKey).(uuid.UUID)
	return id, ok
}

func UserID(ctx context.Context) (uuid.UUID, bool) {
	id, ok := ctx.Value(UserIDKey).(uuid.UUID)
	return id, ok
}
