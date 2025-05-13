# PostgreSQL Client Library Research for PR1V threat-db Service

## Problem Statement

The `threat-db` service in the PR1V project consistently crashes when attempting to import the `pg` (node-postgres) module. This issue has been observed with multiple versions of `pg` (including the 8.x series and version 7.18.2) in the current Node.js environment (v22.13.0) when using `ts-node` for TypeScript execution. This prevents the `threat-db` service from connecting to its PostgreSQL database and becoming operational.

## Alternatives Researched

To address this, several alternative PostgreSQL client libraries and ORMs for Node.js were investigated:

1.  **`Postgres.js` (porsager/postgres)**
    *   **Type:** Direct PostgreSQL client library.
    *   **Key Features:** Claims to be the fastest full-featured PostgreSQL client for Node.js, Deno, Bun, and Cloudflare. It utilizes ES6 Tagged Template Strings for queries, which enhances safety and provides a modern API. It has good TypeScript support and is actively maintained (latest release noted around October 2024).
    *   **Compatibility:** Designed for modern JavaScript environments and appears compatible with recent Node.js versions. Its GitHub page indicates ongoing development and support.
    *   **Suitability:** Appears to be a strong candidate for a direct replacement of `pg`, potentially requiring less extensive code modification than a full ORM.

2.  **`Sequelize`**
    *   **Type:** Object-Relational Mapper (ORM).
    *   **Key Features:** A mature and widely-used ORM supporting PostgreSQL, MySQL, MariaDB, SQLite, and SQL Server. It offers robust TypeScript support.
    *   **Compatibility:** Well-established in the Node.js ecosystem and compatible with TypeScript.
    *   **Suitability:** While powerful, migrating to Sequelize would involve a more significant change in how the application interacts with the database (e.g., defining models). This might be more effort than necessary if the `threat-db` service's database interactions are relatively simple.

3.  **`Prisma`**
    *   **Type:** Next-generation ORM.
    *   **Key Features:** Known for its excellent TypeScript support, type safety, and auto-generated query builder. Provides a modern developer experience.
    *   **Compatibility:** Works well with Node.js and TypeScript.
    *   **Suitability:** Similar to Sequelize, Prisma is a full ORM and would represent a larger architectural change compared to replacing `pg` with another client library.

4.  **`Knex.js`**
    *   **Type:** SQL Query Builder.
    *   **Key Features:** A flexible query builder that can work with various database drivers, including `pg`. It helps construct SQL queries programmatically.
    *   **Compatibility:** Works with Node.js and TypeScript.
    *   **Suitability:** While useful for building queries, Knex.js typically relies on an underlying driver like `pg`. If `pg` itself is the source of the problem, Knex.js alone wouldn't resolve the import crash, though it could be used in conjunction with a different, working driver.

## Recommendation

Based on the research, the recommended approach is to **first attempt replacing the `pg` module with `Postgres.js` in the `threat-db` service.**

**Reasons for this recommendation:**

*   **Direct Replacement:** `Postgres.js` is a client library, similar in role to `pg`. This means the migration path is likely to be more straightforward and involve fewer code changes compared to adopting a full ORM like Sequelize or Prisma.
*   **Modern and Maintained:** It is actively maintained, designed for modern JavaScript/TypeScript environments (including ES Modules), and claims high performance and compatibility.
*   **API:** Its use of tagged template literals for queries is a modern and safe approach.

If `Postgres.js` also proves problematic, then considering a more robust ORM like Sequelize or Prisma would be the next logical step, despite the increased integration effort.

## Proposed Next Steps (if `Postgres.js` is chosen)

1.  **Uninstall `pg`:** Remove the `pg` module from the `services/threat-db` dependencies.
2.  **Install `postgres`:** Add the `postgres` npm package to the `services/threat-db` dependencies.
3.  **Refactor `threat-db`:** Modify `services/threat-db/index.ts` to:
    *   Import `postgres`.
    *   Update the database connection logic to use the `postgres` API.
    *   Adapt any existing database query code to the `Postgres.js` syntax (tagged template literals).
4.  **Test:** Thoroughly test the `threat-db` service to ensure it can connect to the database, execute queries, and operate as expected with the new library.
