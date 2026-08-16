package middleware

import (
	"context"
	"net/http"

	"github.com/google/uuid"
)

func Authenticate(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// TODO: Pull from JWT
		userID := uuid.MustParse("00000000-0000-0000-0000-000000000000")      // Placeholder
		householdID := uuid.MustParse("01a00b8e-1f61-75f3-b002-26a384023f53") // Placeholder
		var err error

		if err != nil {
			http.Error(w, "401 Unauthorized", http.StatusUnauthorized)
			return
		}

		ctx := r.Context()
		ctx = context.WithValue(ctx, UserIDKey, userID)
		ctx = context.WithValue(ctx, HouseholdIDKey, householdID)

		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
