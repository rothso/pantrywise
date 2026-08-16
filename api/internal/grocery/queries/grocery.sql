-- name: GetGroceryLists :many
SELECT list_id as id,
       name,
       created_at,
       updated_at
FROM pantrywise.pantry.grocery_lists
WHERE household_id = $1;