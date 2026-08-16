# Pantrywise Database Migrations

This directory contains database migrations managed by [Goose](https://github.com/pressly/goose).

## Running Migrations

### Prerequisites

- goose CLI installed: `go install github.com/pressly/goose/v3/cmd/goose@latest`
- `.env` file configured with `GOOSE_DRIVER`, `GOOSE_DBSTRING`, and `GOOSE_MIGRATION_DIR`
- PostgreSQL database running (this project uses Neon)

### Common Commands

**View migration status**:

```bash
goose status
```

**Migrate up (run all pending migrations)**:

```bash
goose up
```

**Migrate down (rollback one migration)**:

```bash
goose down
```

**Migrate to a specific version**:

```bash
goose goto 20260507000001
```

## Migration File Naming

Goose uses the naming convention: `{TIMESTAMP}_{DESCRIPTION}.sql`

- **TIMESTAMP**: YYYYMMDDHHmmss (sortable)
- **DESCRIPTION**: Human-readable migration description

Example: `20260507000001_init.sql`

## Migration File Structure

Each migration file contains two sections delimited by special comments:

```sql
-- +goose Up
-- SQL statements to apply migration

-- +goose Down
-- SQL statements to rollback migration
```

## PostgreSQL Best Practices

**Naming Conventions**

- Table names: `snake_case` (plural for collections)
- Column names: `snake_case`
- Index names: `idx_{table}_{columns}`

**Data Types**

- UUID for all primary keys (using `gen_random_uuid()`)
- `TEXT` for strings (no character limits)
- `NUMERIC` for quantities
- `TIMESTAMP` for date/time (stores UTC)
- `INTEGER` for prices (stored in cents to avoid floating point issues)

**Multi-Tenancy**

- `households` table is the tenant boundary
- All household-specific tables have `household_id` foreign key
- Don't use cascading deletes for data cleanup, to avoid accidental data loss
- Unique constraints include tenant context where appropriate

**Performance**

- Indexes on foreign keys for join performance
- Indexes on commonly queried columns (household_id, email, food_id)
- Primary keys and foreign key constraints

**Audit Trail**

- `created_at` and `updated_at` timestamps on all tables
- Automatic defaults using `DEFAULT CURRENT_TIMESTAMP`

**Data Integrity**

- Foreign key constraints when possible
- `ON DELETE SET NULL` for optional relationships
- `UNIQUE` constraints for natural keys (e.g., email per household)

## Adding New Migrations

Create a new migration file:

```bash
# Manual: Create {timestamp}_{description}.sql with +goose Up/Down sections
# Or use template from existing migration
```

Always include:

1. All `CREATE` statements in `-- +goose Up`
2. All `DROP` statements in `-- +goose Down` (reverse order of creation)
3. Proper foreign key relationships
4. Indexes for performance

