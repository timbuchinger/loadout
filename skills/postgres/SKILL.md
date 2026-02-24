---
name: postgres
description: PostgreSQL database management for day-to-day operations. Use when the user needs to run SQL queries, inspect schemas, manage tables, monitor performance, handle backups, or administer a PostgreSQL database via psql or DATABASE_URL.
---

# PostgreSQL 🐘

PostgreSQL database management — queries, schema inspection, inserts, updates, and performance monitoring.

## Setup

```bash
export DATABASE_URL="postgresql://user:pass@localhost:5432/dbname"
```

Connect using psql:

```bash
psql "$DATABASE_URL"
# or
psql -h localhost -U user -d dbname
```

## Essential psql Meta-Commands

| Command | Description |
|---|---|
| `\l` | List all databases |
| `\c dbname` | Connect to a database |
| `\dt [pattern]` | List tables (optionally filtered) |
| `\d tablename` | Describe a table (columns, types, constraints) |
| `\d+ tablename` | Describe with extra detail (storage, comments) |
| `\di` | List indexes |
| `\dv` | List views |
| `\df` | List functions |
| `\dn` | List schemas |
| `\du` | List roles/users |
| `\conninfo` | Show current connection info |
| `\timing` | Toggle query timing |
| `\x` | Toggle expanded output mode |
| `\e` | Open query in `$EDITOR` |
| `\i file.sql` | Execute SQL from a file |
| `\o file.txt` | Send output to a file |
| `\q` | Quit |

## Common Operations

### Query

```sql
SELECT * FROM users LIMIT 10;
SELECT column1, column2 FROM table WHERE condition ORDER BY column1 DESC;
```

### Insert / Update / Delete

```sql
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
UPDATE users SET email = 'new@example.com' WHERE id = 1;
DELETE FROM users WHERE id = 1;
```

### Schema

```sql
-- Create table
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  total NUMERIC(10,2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add / drop column
ALTER TABLE orders ADD COLUMN status TEXT DEFAULT 'pending';
ALTER TABLE orders DROP COLUMN status;

-- Create index
CREATE INDEX CONCURRENTLY idx_orders_user_id ON orders(user_id);
```

### Transactions

```sql
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
-- or ROLLBACK; to undo
```

## Performance & Monitoring

```sql
-- Slow queries (requires pg_stat_statements extension)
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

-- Active connections
SELECT pid, usename, application_name, state, query
FROM pg_stat_activity
WHERE state != 'idle';

-- Table sizes
SELECT relname AS table, pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC;

-- Explain query plan
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 42;

-- Kill a blocking query
SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE pid = <pid>;
```

## Backup & Restore

```bash
# Dump a database
pg_dump "$DATABASE_URL" -Fc -f backup.dump

# Restore
pg_restore -d "$DATABASE_URL" backup.dump

# Plain SQL dump
pg_dump "$DATABASE_URL" > backup.sql
psql "$DATABASE_URL" < backup.sql
```

## Copy (Bulk Import/Export)

```bash
# Export table to CSV
psql "$DATABASE_URL" -c "\copy orders TO 'orders.csv' CSV HEADER"

# Import CSV into table
psql "$DATABASE_URL" -c "\copy orders FROM 'orders.csv' CSV HEADER"
```

## Safety Rules

1. **Always confirm** before running `DELETE`, `DROP`, or `TRUNCATE`
2. **Always backup** before schema migrations
3. **Use transactions** for multi-step data changes
4. Use `EXPLAIN ANALYZE` to preview query plans before running on large tables
5. Prefer `CREATE INDEX CONCURRENTLY` to avoid locking tables in production

## Reference

Full psql documentation: <https://www.postgresql.org/docs/current/app-psql.html>

Retrieve and read this page if you need meta-commands, options, or behaviour not covered above.
