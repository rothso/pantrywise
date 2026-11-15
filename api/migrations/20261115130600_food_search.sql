-- +goose Up
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE INDEX idx_foods_household_name_prefix
    ON pantry.foods (household_id, lower(name) text_pattern_ops);

CREATE INDEX idx_foods_name_trgm
    ON pantry.foods USING GIN (lower(name) gin_trgm_ops);

-- +goose Down
DROP INDEX IF EXISTS pantry.idx_foods_name_trgm;
DROP INDEX IF EXISTS pantry.idx_foods_household_name_prefix;
DROP EXTENSION IF EXISTS pg_trgm;
