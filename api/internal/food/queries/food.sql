-- name: SearchFoods :many
WITH search AS (
    SELECT lower(btrim(@query)) AS term,
           replace(
               replace(
                   replace(lower(btrim(@query)), E'\\', E'\\\\'),
                   '%', E'\\%'
               ),
               '_', E'\\_'
           ) || '%' AS prefix
)
SELECT f.food_id AS id,
       f.name
FROM pantry.foods AS f
CROSS JOIN search AS s
WHERE f.household_id = @household_id
  AND s.term <> ''
  AND (
      lower(f.name) LIKE s.prefix ESCAPE E'\\'
      OR lower(f.name) % s.term
      OR s.term <% lower(f.name)
  )
ORDER BY
    (lower(f.name) LIKE s.prefix ESCAPE E'\\') DESC,
    GREATEST(
        similarity(lower(f.name), s.term),
        word_similarity(s.term, lower(f.name))
    ) DESC,
    lower(f.name),
    f.food_id
LIMIT 20;

-- name: GetInitialSearchFoods :many
WITH household_usage AS (
    SELECT gi.food_id,
           count(*) AS usage_count,
           max(COALESCE(gi.purchase_date, gi.created_at)) AS last_used
    FROM pantry.grocery_items AS gi
    JOIN pantry.grocery_lists AS gl ON gl.list_id = gi.list_id
    WHERE gl.household_id = @household_id
    GROUP BY gi.food_id
)
SELECT f.food_id AS id,
       f.name
FROM pantry.foods AS f
LEFT JOIN household_usage AS hu ON hu.food_id = f.food_id
WHERE f.household_id = @household_id
ORDER BY hu.usage_count DESC NULLS LAST,
         hu.last_used DESC NULLS LAST,
         f.updated_at DESC,
         f.name,
         f.food_id
LIMIT 20;