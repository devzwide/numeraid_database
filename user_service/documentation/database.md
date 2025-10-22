# Database steps

## User Service Database Setup and Baselining Documentation

The following steps document the initial creation and configuration of the `user_service_db`, including the establishment of its schema and the setup of the Flyway migration tool.

### 1\. Database Creation and Schema Initialization

The initial database, tables, and constraints for the User and Profile Management Service were created by executing a single SQL script.

| Action | Command/SQL | Purpose |
| :--- | :--- | :--- |
| **Database Creation** | `CREATE DATABASE user_service_db;` | Created the new database dedicated to user and identity data. |
| **Schema Execution** | (Full script executed) | Created the core tables (`"user"`, `staff`, `student`) and applied initial structural adjustments and indexes. |

#### Core Tables Created:

| Table | Primary Key | Description |
| :--- | :--- | :--- |
| **`"user"`** | `user_id` (`SERIAL`) | Stores primary user authentication and profile details. |
| **`staff`** | `staff_id` (`INT`) | Extends the `user` table for staff-specific details (FK to `user_id`). |
| **`student`** | `student_id` (`INT`) | Extends the `user` table for student-specific details (FK to `user_id`). |

#### Key Schema Adjustments:

* **Social Login Support:** The `"user"` table was altered to allow `password_hash` and `username` to be optional (`DROP NOT NULL`), and new columns (`social_provider_id`, `social_provider`) were added with a unique index.
* **Foreign Keys:** `staff_id` and `student_id` are linked to `"user"(user_id)` with `ON DELETE CASCADE` rules.
* **Indexes:** Indexes for fast lookups were created on `email`, `username`, `role` (on the `"user"` table), and on key columns in the extension tables.

-----

### 2\. Migration Tool Setup and Baselining (Flyway)

The Flyway migration tool was installed and configured to recognize the existing database schema as the starting point (Version 1).

| Action | Command/Tool | Purpose |
| :--- | :--- | :--- |
| **Flyway Installation** | `sudo snap install flyway` | Installed the Flyway CLI tool (Community Edition 7.0.2 via snap). |
| **Configuration** | (`flyway.conf` setup) | Configured Flyway to connect to `jdbc:postgresql://localhost:5432/user_service_db` and pointed it to the local `user_service_db/migrations` folder. |
| **Baselining** | `flyway baseline` | Instructed Flyway to **skip** running the `V1__initial_schema.sql` file and instead create the `flyway_schema_history` table, marking **Version 1** as **Successfully Completed**. |

#### Flyway Baseline Output:

```
Successfully baselined schema with version: 1
```

**Result:** The database is now at migration **Version 1**, and any future structural changes must be applied via new versioned scripts (`V2__...`, `V3__...`) using the `flyway migrate` command.

**(Note: Per instructions, no data seeding was performed on this service.)**