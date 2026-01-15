FROM migrate/migrate:v4.19.1 as base

FROM base as dev
COPY 001_database_dump.sql  /app/migrations/

FROM base as production
COPY *.sql  /app/migrations/