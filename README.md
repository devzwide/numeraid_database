# Numeraid Database

This repository contains the database schema, migrations, and documentation for the Numeraid user service.

## Structure

- `user_service/migrations/` — Flyway migration scripts for the user service database
- `user_service/documentation/` — Database documentation
- `user_service/flyway_userservice.conf` — Flyway configuration for migrations

## Getting Started

1. Clone the repository
2. Copy `.env.example` to `.env` and set your database credentials:
   ```bash
   cp .env.example .env
   # Edit .env to match your environment
   ```
3. Use the provided script to run Flyway commands (it will load environment variables automatically):
   ```bash
   ./migrate.sh migrate
   ./migrate.sh info
   ./migrate.sh clean
   # etc.
   ```

## Requirements
- Flyway
- Supported SQL database (e.g., PostgreSQL, MySQL)
- Bash shell (for the script)

## Environment Variables
The following environment variables must be set (see `.env.example`):
- `FLYWAY_URL` — JDBC URL for your database
- `FLYWAY_USER` — Database username
- `FLYWAY_PASSWORD` — Database password

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
See [LICENSE](LICENSE) for details.
