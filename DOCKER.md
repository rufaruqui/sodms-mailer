# Docker Setup Guide

This guide will help you run the SODMS Mailer application using Docker.

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 1.29+

## Important Note

This application uses Ruby 2.3.3 which runs on Debian Jessie (archived). The Dockerfile automatically configures archived repositories to ensure packages can be installed.

## Quick Start

1. **Clone the repository** (if not already done)

2. **Create environment file**
   ```bash
   cp .env.example .env
   ```
   Edit `.env` to configure your backend URLs if needed.

3. **Build and start all services**
   ```bash
   docker-compose up
   ```

   The first time you run this, it will:
   - Build the Rails application image
   - Pull MySQL and Redis images
   - Create and migrate the database
   - Start all services

4. **Access the application**
   - Web UI: http://localhost:3000
   - Resque Web UI: http://localhost:3000/resque_web

## Services

The `docker-compose.yml` defines the following services:

| Service | Description | Port |
|---------|-------------|------|
| `web` | Rails web server | 3000 |
| `worker` | Resque background worker | - |
| `scheduler` | Resque scheduler for cron jobs | - |
| `db` | MySQL 5.7 database | 3306 |
| `redis` | Redis 3 for job queue | 6379 |

## Common Commands

### Starting Services

```bash
# Start all services in foreground
docker-compose up

# Start all services in background
docker-compose up -d

# Start specific service
docker-compose up web
```

### Viewing Logs

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f worker
docker-compose logs -f scheduler
```

### Running Commands

```bash
# Access Rails console
docker-compose exec web bundle exec rails console

# Run rake tasks
docker-compose exec web rake prepare_container_reports
docker-compose exec web rake send_container_reports
docker-compose exec web rake check_undelivered_emails
docker-compose exec web rake send_test_mail

# Run database migrations
docker-compose exec web rake db:migrate

# Access MySQL database
docker-compose exec db mysql -u root -ppassword sapl_mailer_dev
```

### Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes all data)
docker-compose down -v
```

### Rebuilding

```bash
# Rebuild images
docker-compose build

# Rebuild specific service
docker-compose build web

# Rebuild and restart
docker-compose up --build
```

## Development Workflow

1. **Make code changes** - The application directory is mounted as a volume, so changes are reflected immediately.

2. **Restart web server** if needed:
   ```bash
   docker-compose restart web
   ```

3. **View logs** to debug:
   ```bash
   docker-compose logs -f web
   ```

4. **Run tests** (when test suite is configured):
   ```bash
   docker-compose exec web bundle exec rails test
   ```

## Environment Variables

Create a `.env` file to customize configuration:

```bash
# Backend URLs
LOCAL_BACKEND_BASE=http://your-local-backend:5000
SODMS_BACKEND_BASE=http://your-sodms-backend:8070

# Database
DATABASE_HOST=db

# Redis
REDIS_URL=redis://redis:6379/0
```

## Volumes

Persistent data is stored in Docker volumes:

- `mysql_data` - MySQL database files
- `redis_data` - Redis persistence files
- `bundle_cache` - Ruby gems (speeds up rebuilds)

To remove all volumes and start fresh:
```bash
docker-compose down -v
```

## Troubleshooting

### Database connection errors
```bash
# Check if database is running
docker-compose ps db

# Check database logs
docker-compose logs db

# Manually create database
docker-compose exec web rake db:create
```

### Redis connection errors
```bash
# Check if Redis is running
docker-compose ps redis

# Check Redis logs
docker-compose logs redis
```

### Port already in use
If port 3000 is already in use, edit `docker-compose.yml`:
```yaml
web:
  ports:
    - "3001:3000"  # Change 3001 to any available port
```

### Code changes not reflected
```bash
# Restart the web service
docker-compose restart web

# If still not working, rebuild
docker-compose up --build web
```

### Worker not processing jobs
```bash
# Check worker logs
docker-compose logs -f worker

# Restart worker
docker-compose restart worker

# Check Resque Web UI
# http://localhost:3000/resque_web
```

## Production Deployment

This Docker setup is configured for **development only**. For production:

1. Use the existing Capistrano deployment process
2. Or create a separate `docker-compose.prod.yml` with:
   - PostgreSQL instead of MySQL
   - Production environment variables
   - Proper secret management
   - Volume mounting for reports and logs
   - Reverse proxy (nginx)

## Differences from Local Setup

| Aspect | Docker | Local |
|--------|--------|-------|
| Database Host | `db` (container name) | `localhost` |
| Redis URL | `redis://redis:6379/0` | `redis://localhost:6379/0` |
| Dependencies | Isolated in containers | Installed on host |
| Port Binding | Configurable in compose file | Uses default Rails port |
