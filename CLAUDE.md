# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SODMS Mailer is a Rails 5.0.6 application that generates and sends automated email reports (cargo and container reports) to clients on a scheduled basis. It retrieves data from the SODMS backend API, generates Excel reports, and manages email delivery using background job processing.

## Technology Stack

- **Framework**: Ruby on Rails 5.0.6
- **Ruby Version**: 2.3.3 (specified in `.ruby-version`)
- **Background Jobs**: Resque with resque-scheduler for scheduled tasks
- **Queue**: Redis
- **Databases**:
  - Development/Test: MySQL2
  - Production: PostgreSQL
- **Deployment**: Capistrano with systemd services
- **Report Generation**: Axlsx (Excel files)

## Development Commands

### Docker Setup (Recommended)

```bash
# Build and start all services (web, worker, scheduler, MySQL, Redis)
docker-compose up

# Build images
docker-compose build

# Start in detached mode
docker-compose up -d

# View logs
docker-compose logs -f web
docker-compose logs -f worker
docker-compose logs -f scheduler

# Run rake tasks in container
docker-compose exec web rake prepare_container_reports
docker-compose exec web rake send_container_reports
docker-compose exec web rake check_undelivered_emails

# Access Rails console
docker-compose exec web bundle exec rails console

# Stop all services
docker-compose down

# Remove volumes (database, redis data)
docker-compose down -v
```

**Docker Services:**
- `web` - Rails server on port 3000
- `worker` - Resque worker processing jobs
- `scheduler` - Resque scheduler for cron-like tasks
- `db` - MySQL 5.7 database
- `redis` - Redis 3 for job queue

**Environment Variables:**
Create a `.env` file in the root directory to override defaults:
```bash
LOCAL_BACKEND_BASE=http://your-backend-url:5000
SODMS_BACKEND_BASE=http://your-sodms-backend:8070
```

### Local Setup (Without Docker)

```bash
bundle install
rake db:create db:migrate
```

### Running the Application (Local)
```bash
# Start all services (web + workers + scheduler)
bundle exec foreman start

# Or start individually:
bundle exec rails server                                    # Web server
QUEUE=* bundle exec rake environment resque:work            # Resque worker
QUEUE=* bundle exec rake environment resque:scheduler       # Resque scheduler
```

### Rake Tasks
```bash
# Report generation and delivery tasks
rake prepare_cargo_reports          # Prepare daily cargo reports
rake prepare_container_reports      # Prepare daily container reports
rake send_container_reports         # Send daily container reports
rake check_undelivered_emails       # Check and retry undelivered emails
rake send_test_mail                 # Send test email

# Dynamic scheduling
rake set_schedule_dym              # Set dynamic schedules for report tasks
```

### Deployment
```bash
# Deploy to production
bundle exec cap production deploy

# Deploy to staging
bundle exec cap staging deploy
```

### Monitoring
- Resque Web UI: `http://localhost:3000/resque_web` (when server is running)
- Docker: Access at `http://localhost:3000/resque_web` when using `docker-compose up`

## Architecture

### Core Components

**Background Jobs** (`app/jobs/`)
- Jobs enqueue tasks to Resque for asynchronous processing
- Key jobs: `CreateCargoReportsJob`, `CreateContainerReportsJob`, `SendContainerReportsJob`, `CheckUndeliveredEmailsJob`
- Jobs use `perform_later` which delegates to Resque

**Service Objects** (`app/services/`)
- Business logic is organized into service classes following single responsibility principle
- **Authentication**: `AuthService` - Manages token-based auth with SODMS backend, caches tokens until expiry
- **Data Retrieval Services**: `RetrieveCargoData`, `RetrieveClientContainerData`, `RetrieveImportContainerData` - Fetch data from SODMS API
- **Report Creation Services**: `CreateCargoReport`, `CreateContainerReport`, `CreateImportContainerReport` - Orchestrate report generation
- **Excel Generation Services**: `CreateCargoReportXls`, `CreateClientContainerReportXls`, `CreateImportContainerReportXls` - Generate Excel files using Axlsx
- **Email Services**: `CreateCargoReportEmail`, `CreateClientContainerReportEmail`, `CreateImportContainerReportEmail` - Prepare email content
- **Delivery**: `SendEmailReport` - Handle email sending via `ReportMailer`

**Mailers** (`app/mailers/`)
- `ReportMailer` - Sends reports with Excel attachments
- Uses `resque_mailer` to queue emails asynchronously
- Default queue: `saplmailer`

**Models** (`app/models/`)
- `Email`: Tracks email records with states (created, sent, delivered, failed)
- `MailType`: Defines different types of emails
- `Scheduler`: Stores scheduled task configurations

### Data Flow

1. Scheduled task triggers (via cron or resque-scheduler)
2. Job enqueues work to Resque
3. Resque worker picks up job
4. Service retrieves data from SODMS backend (authenticated via `AuthService`)
5. Report generation service creates Excel file
6. Email service prepares email with attachment
7. Mailer sends email (queued via `resque_mailer`)
8. Email record updated with delivery status

### Configuration Files

- `config/environment_var.yml` - Environment-specific variables (SODMS backend URL, secret keys)
- `config/sapl_schedule.yml` - Resque-scheduler cron schedules for recurring jobs
- `config/database.yml` - Database configurations per environment
- `config/initializers/resque_mailer.rb` - Resque and Redis configuration
- `Procfile` - Process definitions for Foreman (web, worker, scheduler)

### Scheduled Tasks

Configured in `config/sapl_schedule.yml`:
- Container reports sent at 9:45 AM and 6:16 PM daily
- Cron syntax or rufus-scheduler "every" syntax supported

Production cron jobs (from deployment docs):
- Report preparation: 8:40 AM
- Report sending: 8:45 AM
- Undelivered email checks: 8:50 AM, 9:15 AM, 9:30 AM, 10:15 AM
- Old report cleanup: 6:00 PM (removes files >30 days)

### Production Deployment

- Uses Capistrano for zero-downtime deployments
- RVM for Ruby version management
- Three systemd services: `sodmsmailer-web`, `sodmsmailer-worker`, `sodmsmailer-scheduler`
- Deployed to `/var/www/sodmsmailer/current`
- Redis required for Resque job queue
- PostgreSQL database in production

## Important Notes

- **Authentication Caching**: `AuthService` caches access tokens until expiry to reduce API calls to SODMS backend
- **Queue Name**: Default Resque queue is `saplmailer` (configurable in resque_mailer initializer)
- **Error Handling**: Resque jobs re-enqueue on SIGTERM (graceful shutdown)
- **Report Storage**: Generated reports stored in `reports/` directory
- **Database Adapters**: MySQL2 for dev/test, PostgreSQL for production
- **Environment Variables**: Backend URLs and secrets in `config/environment_var.yml` (gitignored in production, use `config/local_env.yml` for local overrides)
