-- +goose Up
DROP INDEX IF EXISTS pantry.idx_grocery_items_store_id;
ALTER TABLE pantry.grocery_items DROP COLUMN store_id;
DROP TABLE pantry.store_listings;
DROP TABLE pantry.stores;

DROP INDEX IF EXISTS pantry.idx_recipes_recipe_category_id;
ALTER TABLE pantry.recipes DROP COLUMN category_id;
DROP TABLE pantry.recipe_categories;
ALTER TABLE pantry.recipe_ingredients DROP COLUMN preparation;

-- +goose Down
CREATE TABLE pantry.stores (
    store_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

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

ALTER TABLE pantry.grocery_items
    ADD COLUMN store_id UUID REFERENCES pantry.stores(store_id);

CREATE INDEX idx_stores_household_id ON pantry.stores(household_id);
CREATE INDEX idx_store_listings_store_id ON pantry.store_listings(store_id);
CREATE INDEX idx_store_listings_food_id ON pantry.store_listings(food_id);
CREATE INDEX idx_grocery_items_store_id ON pantry.grocery_items(store_id);

CREATE TABLE pantry.recipe_categories (
    category_id UUID PRIMARY KEY DEFAULT uuidv7(),
    household_id UUID NOT NULL REFERENCES pantry.households(household_id),
    name TEXT NOT NULL,
    color_rgba INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(household_id, name)
);

ALTER TABLE pantry.recipes
    ADD COLUMN category_id UUID REFERENCES pantry.recipe_categories(category_id);

CREATE INDEX idx_recipe_categories_household_id ON pantry.recipe_categories(household_id);
CREATE INDEX idx_recipes_recipe_category_id ON pantry.recipes(category_id);
ALTER TABLE pantry.recipe_ingredients ADD COLUMN preparation TEXT;
