# AGENTS.md - Pantrywise Backend Guide

## Project Overview

**Pantrywise** is a Go REST API for managing household grocery inventories and recipes. It's designed as a multi-tenant
system where Users belong to Households, and each Household has Grocery Lists containing Items linked to Foods and
Stores.

### Core Architecture

- **Framework**: Standard library `http.ServeMux` (no external routing framework)
- **Database**: PostgreSQL via `pgx` connection pool with automatic pooling
- **Transport**: HTTP with JSON (implicitly; handlers not yet sending responses)
- **Structure**: Domain-driven with `internal/` packages for separate concerns

## Design Patterns

### 1. Dependency Injection Pattern

The server wires dependencies at startup (`cmd/api/main.go`):

```go
srv := pantry.NewServer(
&grocery.Repo{DB: db}, // Repo holds *pgxpool.Pool
)
```

**Key Point**: Handlers are created via factory functions that capture the Repo:

```go
// grocery_handler.go
func HandleList(repo *Repo) http.HandlerFunc {
return func (w http.ResponseWriter, r *http.Request) { ... }
}
```

All new handlers must follow this pattern—pass dependencies via closure, not global state.

### 2. Middleware & Context

Authentication flows through `middleware.Authenticate` which:

1. Validates credentials (currently TODO: JWT extraction)
2. Stores UserID and HouseholdID in `context.Context`
3. Uses typed context keys (`HouseholdIDKey`, `UserIDKey`) in `middleware/context.go`

**To access IDs in handlers**:

```go
householdID, ok := middleware.HouseholdID(r.Context())
userID, ok := middleware.UserID(r.Context())
```

### 3. Repository Pattern for Data Access

Each domain module has a `Repo` struct holding `*pgxpool.Pool`. Queries go through repo methods:

```go
type Repo struct {
DB *pgxpool.Pool
}

func (r *Repo) GetGroceryList(ctx context.Context) ([]List, error) {
// SQL queries here using pgx, context for cancellation
rows, err := r.DB.Query(ctx, "SELECT ... FROM grocery_lists")
defer rows.Close()
}
```

**Convention**:

- Methods always accept `context.Context` as first parameter (for timeouts/cancellation)
- Return `(T, error)` pattern
- Use `r.DB.Query()`, `r.DB.QueryRow()`, or `r.DB.Exec()` with context as first arg
- pgx provides better performance and batch operations vs database/sql

### 4. Configuration & Environment

- Config loaded via `internal/config/Load()` at startup
- Uses `godotenv` to load `.env` file (optional, for local dev)
- Required env vars parsed with `getRequiredEnv()` (fatal if missing)
- Optional vars use `getEnv(key, fallback)`

**Current required**: `DATABASE_URL` (PostgreSQL connection string)

### 5. Domain Models & Cross-Domain References

Models live at package level (`internal/grocery/grocery.go`, `internal/food.go`, etc.):

- `Grocery.List` contains `[]Item`
- `Item` references `*Food`, `*Store`, `[]Recipe`
- All entities use `uuid.UUID` from `google/uuid`
- `Unit` is an enum string (g, ml, cups, pcs, tsp)

**Pattern**: Pointers for optional relationships, slices for 1-to-many.

### 6. Routing Registration

Routes added in `server.routes()`:

```go
func (s *Server) routes() {
protected := http.NewServeMux()
protected.HandleFunc("GET /grocery", grocery.HandleList(s.groceryRepo))

s.router.Handle("/", middleware.Authenticate(protected))
}
```

**Key**: Protected routes go in a submux wrapped by middleware. New routes require:

1. Add handler in domain package (e.g., `grocery.HandleCreate`)
2. Register in `protected.HandleFunc("METHOD /path", ...)`

### 7. Testing & Build Patterns

- Package is `module Pantrywise` (see `go.mod`)
- Standard `go run`, `go build`, `go test` commands
- Tests should follow Go convention: `*_test.go` files, `Testing` or `Test` prefix for test packages

### 8. Environment Setup & Database Migrations

Create `.env` in project root:

```
DATABASE_URL=postgres://user:password@localhost:5432/Pantrywise
ADDR=:8080
```

**Migrations with Goose**:

- All migrations live in `migrations/` directory
- Run migrations from the root directory before starting the server:
  ```bash
  goose up
  ```
- Check status: `goose status`
- Rollback one migration: `goose down`

Run API: `go run ./cmd/api/main.go`

## Key Files to Know

| File                                           | Purpose                                      |
|------------------------------------------------|----------------------------------------------|
| `cmd/api/main.go`                              | Entry point, wires dependencies              |
| `internal/server/server.go`                    | HTTP server, routes setup                    |
| `internal/config/config.go`                    | Config loading from env                      |
| `internal/middleware/auth.go`                  | Auth middleware (JWT TODO)                   |
| `internal/grocery/{grocery,_handler,_repo}.go` | Grocery domain (model, handler, data access) |
| `internal/food.go`                             | Food entity and Unit constants               |
| `migrations/`                                  | Goose SQL migrations                         |

**Key Design**:

- All rows include `created_at`/`updated_at` (audit trail)
- UUIDs for all primary keys
- Prices stored as `INTEGER` (cents, not float)
- Colors stored as `INTEGER`

## Common Tasks

### Adding a New Endpoint

1. Create handler function in domain package: `func HandleCreate(repo *Repo) http.HandlerFunc`
2. Implement repo method for data access: `func (r *Repo) Create(ctx context.Context, ...) error`
3. Register in `server.routes()`: `protected.HandleFunc("POST /path", domain.HandleCreate(s.domainRepo))`
4. Extract IDs from context: `householdID, _ := middleware.HouseholdID(r.Context())`

### Adding Database Interaction

- All queries use `r.DB.Query(ctx, ...)`, `r.DB.QueryRow(ctx, ...)`, or `r.DB.Exec(ctx, ...)`
- Context must be first parameter in pgx calls
- Always accept `context.Context` in repo methods
- Handle PostgreSQL errors explicitly (pgx returns `pgx.PgError` for database errors)
- Example: `rows, err := r.DB.Query(ctx, "SELECT id, name FROM foods WHERE household_id = $1", householdID)`

### Extending the Data Model

- Add structs in domain packages (or root `internal/` for shared types like `Food`)
- Use `uuid.UUID` for IDs, pointers for optional relationships
- Update repos to fetch/persist the new fields

## Known Limitations & TODOs

- JWT authentication not implemented (see `middleware/auth.go` line 10 TODO)
- Handlers not yet returning JSON responses
- No error response formatting standard
- Database schema not initialized

