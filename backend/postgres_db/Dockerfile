FROM flyway/flyway:10 as base

FROM base as dev
COPY sql  /flyway/sql

FROM base as production
COPY sql  /flyway/sql

RUN flyway -v