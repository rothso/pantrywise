-- +goose Up
CREATE SCHEMA IF NOT EXISTS pantry;

-- Create households table (multi-tenant boundary)
CREATE TABLE pantry.households (
    household_id UUID PRIMARY KEY DEFAULT uuidv7(),
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create foods table (household-specific)
CREATE TABLE pantry.foods (
    food_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create stores table (household-specific)
CREATE TABLE pantry.stores (
    store_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create store_listings table (food prices at stores)
CREATE TABLE pantry.store_listings (
    listing_id UUID PRIMARY KEY DEFAULT uuidv7(),
    store_id UUID NOT NULL REFERENCES pantry.stores(store_id),
    food_id UUID NOT NULL REFERENCES pantry.foods(food_id),
    price_cents INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create grocery_lists table
CREATE TABLE pantry.grocery_lists (
    list_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create grocery_items table
CREATE TABLE pantry.grocery_items (
    item_id UUID PRIMARY KEY DEFAULT uuidv7(),
    list_id UUID NOT NULL REFERENCES pantry.grocery_lists(list_id),
    food_id UUID NOT NULL REFERENCES pantry.foods(food_id),
    store_id UUID REFERENCES pantry.stores(store_id),
    quantity NUMERIC NOT NULL,
    unit TEXT NOT NULL,
    purchase_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create recipe_categories table
CREATE TABLE pantry.recipe_categories (
    category_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    color_rgba INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(household_id, name)
);

-- Create recipes table
CREATE TABLE pantry.recipes (
    recipe_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    category_id UUID REFERENCES pantry.recipe_categories(category_id),
    planned_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create recipe_ingredients table
CREATE TABLE pantry.recipe_ingredients (
    ingredient_id UUID PRIMARY KEY DEFAULT uuidv7(),
    recipe_id UUID NOT NULL REFERENCES pantry.recipes(recipe_id),
    food_id UUID NOT NULL REFERENCES pantry.foods(food_id),
    quantity NUMERIC NOT NULL,
    unit TEXT NOT NULL,
    preparation TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for common queries
CREATE INDEX idx_stores_household_id ON pantry.stores(household_id);
CREATE INDEX idx_store_listings_store_id ON pantry.store_listings(store_id);
CREATE INDEX idx_store_listings_food_id ON pantry.store_listings(food_id);
CREATE INDEX idx_grocery_lists_household_id ON pantry.grocery_lists(household_id);
CREATE INDEX idx_grocery_items_grocery_list_id ON pantry.grocery_items(list_id);
CREATE INDEX idx_grocery_items_food_id ON pantry.grocery_items(food_id);
CREATE INDEX idx_grocery_items_store_id ON pantry.grocery_items(store_id);
CREATE INDEX idx_recipe_categories_household_id ON pantry.recipe_categories(household_id);
CREATE INDEX idx_recipes_household_id ON pantry.recipes(household_id);
CREATE INDEX idx_recipes_recipe_category_id ON pantry.recipes(category_id);
CREATE INDEX idx_recipe_ingredients_recipe_id ON pantry.recipe_ingredients(recipe_id);
CREATE INDEX idx_recipe_ingredients_food_id ON pantry.recipe_ingredients(food_id);

-- +goose Down
DROP INDEX IF EXISTS idx_recipe_ingredients_food_id;
DROP INDEX IF EXISTS idx_recipe_ingredients_recipe_id;
DROP INDEX IF EXISTS idx_recipes_recipe_category_id;
DROP INDEX IF EXISTS idx_recipes_household_id;
DROP INDEX IF EXISTS idx_recipe_categories_household_id;
DROP INDEX IF EXISTS idx_grocery_items_store_id;
DROP INDEX IF EXISTS idx_grocery_items_food_id;
DROP INDEX IF EXISTS idx_grocery_items_grocery_list_id;
DROP INDEX IF EXISTS idx_grocery_lists_household_id;
DROP INDEX IF EXISTS idx_store_listings_food_id;
DROP INDEX IF EXISTS idx_store_listings_store_id;
DROP INDEX IF EXISTS idx_stores_household_id;

DROP TABLE IF EXISTS pantry.recipe_ingredients;
DROP TABLE IF EXISTS pantry.recipes;
DROP TABLE IF EXISTS pantry.recipe_categories;
DROP TABLE IF EXISTS pantry.grocery_items;
DROP TABLE IF EXISTS pantry.grocery_lists;
DROP TABLE IF EXISTS pantry.store_listings;
DROP TABLE IF EXISTS pantry.stores;
DROP TABLE IF EXISTS pantry.foods;
DROP TABLE IF EXISTS pantry.households;
