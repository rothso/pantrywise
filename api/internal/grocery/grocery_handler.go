package grocery

import (
	"encoding/json"
	"net/http"

	"pantrywise/internal/middleware"
)

func HandleList(repo *Repo) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		householdID, ok := middleware.HouseholdID(r.Context())
		if !ok {
			http.Error(w, "household ID not found in context", http.StatusUnauthorized)
			return
		}

		groceryLists, err := repo.GetGroceryLists(r.Context(), householdID)
		if err != nil {
			http.Error(w, "failed to retrieve grocery lists", http.StatusInternalServerError)
			return
		}

		if err = json.NewEncoder(w).Encode(groceryLists); err != nil {
			http.Error(w, "failed to encode grocery lists", http.StatusInternalServerError)
			return
		}
	}
}
