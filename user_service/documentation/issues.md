## Issue 1: Flyway Migration Not Visible Due to Incorrect Configuration Path

**Status:** **RESOLVED**

### Summary

The initial attempt to run Flyway migrations failed because the configuration file (`flyway_userservice.conf`) contained an incorrect relative path for the migration scripts (`flyway.locations`). This prevented Flyway from locating and validating the core schema file (`V1__initial_schema.sql`), leading to unnecessary `baseline` executions and confusion regarding the schema's status.

The issue was resolved by correcting the `flyway.locations` property and subsequently using the `clean` and `migrate` commands to properly initialize the database.

-----

### Steps to Reproduce the Issue (Initial State)

1.  **Configuration Error:** The `flyway_userservice.conf` file was incorrectly set:
    ```properties
    flyway.locations=filesystem:user_service_db/migrations
    ```
2.  **Execution Context:** Running the command from the `user_service/` directory:
    ```bash
    devzwide@Zwide:~/.../user_service$ flyway -configFiles=flyway_userservice.conf info
    ```
3.  **Result:** Flyway connected to the database but failed to locate the `V1__initial_schema.sql` file, resulting in an `info` output that showed only the `BASELINE` record, confirming the file was invisible.

-----

### Resolution

The issue was fixed by modifying the `flyway.locations` property to reflect the correct relative path from the execution directory (`user_service/`).

1.  **Configuration Fix:**

    * **File:** `user_service/flyway_userservice.conf`
    * **Change:** `flyway.locations=filesystem:migrations`

2.  **Database Reset (For Validation):** The existing baselined schema was removed to allow a clean migration execution.

    ```bash
    flyway -configFiles=flyway_userservice.conf clean
    ```

3.  **Successful Migration:** The `migrate` command was run, successfully finding and executing the schema script.

    ```bash
    flyway -configFiles=flyway_userservice.conf migrate
    # Output: Successfully applied 1 migration to schema "public"
    ```

4.  **Verification:** The `info` command confirmed the final, correct state:

    ```bash
    flyway -configFiles=flyway_userservice.conf info
    # Output now correctly shows: | Versioned | 1 | initial schema | SQL | ... | Success |
    ```

### Conclusion

The database schema is now correctly initialized and the Flyway setup is confirmed to be working for future migrations. The corrected configuration file has been committed to the repository.