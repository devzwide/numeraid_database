# Numeraid Database

This repository contains the database schema and migration scripts for the Numeraid User Service. It uses Flyway for version-controlled database migrations.

## Project Structure

- `migrations/` - SQL migration scripts (Flyway format)
- `flyway_userservice.conf` - Flyway configuration file
- `documentation/` - Additional documentation (e.g., `database.md`)

## Getting Started

### Prerequisites
- [Flyway](https://flywaydb.org/) installed
- Access to your target database (PostgreSQL)

### Running Migrations

1. Configure your database connection in `flyway_userservice.conf`.
2. Run migrations:
   ```bash
   flyway -configFiles=flyway_userservice.conf migrate
   ```

### Creating a New Migration

1. Add a new SQL file to the `migrations/` folder following the naming convention: `V<version>__<description>.sql` (e.g., `V2__add_users_table.sql`).
2. Run the migration command as above.

## Contributing

- Fork the repository and create a feature branch.
- Add or modify migration scripts as needed.
- Submit a pull request with a clear description of your changes.

## License

See [LICENSE](LICENSE) for details.

