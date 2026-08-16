-- +goose Up
INSERT INTO pantry.households (name)
SELECT 'Test Household'
WHERE NOT EXISTS (
    SELECT 1
    FROM pantry.households
    WHERE name = 'Test Household'
);

INSERT INTO pantry.foods (household_id, name)
SELECT h.household_id,
       'Milk'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
    SELECT 1
    FROM pantry.foods
    WHERE household_id = h.household_id AND name = 'Milk'
);

INSERT INTO pantry.foods (household_id, name)
SELECT h.household_id,
       'Bread'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
    SELECT 1
    FROM pantry.foods
    WHERE household_id = h.household_id AND name = 'Bread'
);

INSERT INTO pantry.foods (household_id, name)
SELECT h.household_id,
       'Eggs'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
    SELECT 1
    FROM pantry.foods
    WHERE household_id = h.household_id AND name = 'Eggs'
);

INSERT INTO pantry.foods (household_id, name)
SELECT h.household_id,
       'Apples'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
    SELECT 1
    FROM pantry.foods
    WHERE household_id = h.household_id AND name = 'Apples'
);

INSERT INTO pantry.foods (household_id, name)
SELECT h.household_id,
       'Rice'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
    SELECT 1
    FROM pantry.foods
    WHERE household_id = h.household_id AND name = 'Rice'
);

INSERT INTO pantry.stores (household_id, name)
SELECT h.household_id,
       'Farm Fresh'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.stores
      WHERE household_id = h.household_id AND name = 'Farm Fresh'
  );

INSERT INTO pantry.stores (household_id, name)
SELECT h.household_id,
       'Corner Market'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.stores
      WHERE household_id = h.household_id AND name = 'Corner Market'
  );

INSERT INTO pantry.store_listings (store_id, food_id, price_cents, quantity, unit)
SELECT s.store_id,
       f.food_id,
       349,
       1,
       'g'
FROM pantry.stores s
JOIN pantry.foods f ON f.name = 'Milk'
WHERE s.name = 'Farm Fresh'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.store_listings
      WHERE store_id = s.store_id AND food_id = f.food_id
  );

INSERT INTO pantry.store_listings (store_id, food_id, price_cents, quantity, unit)
SELECT s.store_id,
       f.food_id,
       249,
       1,
       'g'
FROM pantry.stores s
JOIN pantry.foods f ON f.name = 'Bread'
WHERE s.name = 'Corner Market'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.store_listings
      WHERE store_id = s.store_id AND food_id = f.food_id
  );

INSERT INTO pantry.grocery_lists (household_id, name)
SELECT h.household_id,
       'Weekly Groceries'
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.grocery_lists
      WHERE household_id = h.household_id AND name = 'Weekly Groceries'
  );

INSERT INTO pantry.grocery_items (list_id, food_id, store_id, quantity, unit, purchase_date)
SELECT gl.list_id,
       f.food_id,
       s.store_id,
       2,
       'g',
       CURRENT_DATE
FROM pantry.grocery_lists gl
JOIN pantry.households h ON h.household_id = gl.household_id
JOIN pantry.foods f ON f.name = 'Milk'
JOIN pantry.stores s ON s.household_id = h.household_id AND s.name = 'Farm Fresh'
WHERE gl.name = 'Weekly Groceries'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.grocery_items
      WHERE list_id = gl.list_id AND food_id = f.food_id
  );

INSERT INTO pantry.grocery_items (list_id, food_id, store_id, quantity, unit, purchase_date)
SELECT gl.list_id,
       f.food_id,
       s.store_id,
       1,
       'g',
       CURRENT_DATE
FROM pantry.grocery_lists gl
JOIN pantry.households h ON h.household_id = gl.household_id
JOIN pantry.foods f ON f.name = 'Bread'
JOIN pantry.stores s ON s.household_id = h.household_id AND s.name = 'Corner Market'
WHERE gl.name = 'Weekly Groceries'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.grocery_items
      WHERE list_id = gl.list_id AND food_id = f.food_id
  );

INSERT INTO pantry.recipe_categories (household_id, name, color_rgba)
SELECT h.household_id,
       'Breakfast',
       0
FROM pantry.households h
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.recipe_categories
      WHERE household_id = h.household_id AND name = 'Breakfast'
  );

INSERT INTO pantry.recipes (household_id, name, category_id, planned_date)
SELECT h.household_id,
       'Eggs and Toast',
       rc.category_id,
       CURRENT_DATE
FROM pantry.households h
JOIN pantry.recipe_categories rc ON rc.household_id = h.household_id AND rc.name = 'Breakfast'
WHERE h.name = 'Test Household'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.recipes
      WHERE household_id = h.household_id AND name = 'Eggs and Toast'
  );

INSERT INTO pantry.recipe_ingredients (recipe_id, food_id, quantity, unit, preparation)
SELECT r.recipe_id,
       f.food_id,
       2,
       'g',
       'scrambled'
FROM pantry.recipes r
JOIN pantry.foods f ON f.name = 'Eggs'
WHERE r.name = 'Eggs and Toast'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.recipe_ingredients
      WHERE recipe_id = r.recipe_id AND food_id = f.food_id
  );

INSERT INTO pantry.recipe_ingredients (recipe_id, food_id, quantity, unit, preparation)
SELECT r.recipe_id,
       f.food_id,
       2,
       'g',
       'toasted'
FROM pantry.recipes r
JOIN pantry.foods f ON f.name = 'Bread'
WHERE r.name = 'Eggs and Toast'
  AND NOT EXISTS (
      SELECT 1
      FROM pantry.recipe_ingredients
      WHERE recipe_id = r.recipe_id AND food_id = f.food_id
  );

-- +goose Down
DELETE FROM pantry.recipe_ingredients
WHERE recipe_id IN (
    SELECT recipe_id
    FROM pantry.recipes
    WHERE household_id = (
        SELECT household_id
        FROM pantry.households
        WHERE name = 'Test Household'
    )
);

DELETE FROM pantry.recipes
WHERE household_id = (
    SELECT household_id
    FROM pantry.households
    WHERE name = 'Test Household'
);

DELETE FROM pantry.recipe_categories
WHERE household_id = (
    SELECT household_id
    FROM pantry.households
    WHERE name = 'Test Household'
);

DELETE FROM pantry.grocery_items
WHERE list_id IN (
    SELECT list_id
    FROM pantry.grocery_lists
    WHERE household_id = (
        SELECT household_id
        FROM pantry.households
        WHERE name = 'Test Household'
    )
);

DELETE FROM pantry.grocery_lists
WHERE household_id = (
    SELECT household_id
    FROM pantry.households
    WHERE name = 'Test Household'
);

DELETE FROM pantry.store_listings
WHERE store_id IN (
    SELECT store_id
    FROM pantry.stores
    WHERE household_id = (
        SELECT household_id
        FROM pantry.households
        WHERE name = 'Test Household'
    )
);

DELETE FROM pantry.stores
WHERE household_id = (
    SELECT household_id
    FROM pantry.households
    WHERE name = 'Test Household'
);

DELETE FROM pantry.foods
WHERE name IN ('Milk', 'Bread', 'Eggs', 'Apples', 'Rice');

DELETE FROM pantry.households
WHERE name = 'Test Household';