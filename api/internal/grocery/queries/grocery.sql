-- name: GetGroceryLists :many
SELECT gl.list_id                        AS id,
       gl.household_id,
       gl.name,
       gl.created_at,
       gl.updated_at,
       gi.item_id,
       gi.food_id                        AS item_food_id,
       f.name                            AS food_name,
       COALESCE(gi.quantity, 0::numeric) AS item_quantity,
       gi.unit                           AS item_unit,
       gi.purchase_date                  AS item_purchase_date
FROM pantrywise.pantry.grocery_lists AS gl
         LEFT JOIN pantrywise.pantry.grocery_items AS gi ON gi.list_id = gl.list_id
         LEFT JOIN pantrywise.pantry.foods AS f ON f.food_id = gi.food_id
WHERE gl.household_id = $1
ORDER BY gl.created_at, gl.list_id, gi.created_at, gi.item_id;