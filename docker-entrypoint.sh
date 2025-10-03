#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
echo "Waiting for database to be ready..."
until nc -z -v -w30 ${DATABASE_HOST:-db} 3306
do
  echo "Waiting for database connection..."
  sleep 1
done
echo "Database is ready!"

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
until nc -z -v -w30 ${REDIS_HOST:-redis} 6379
do
  echo "Waiting for Redis connection..."
  sleep 1
done
echo "Redis is ready!"

# Check if database exists, if not create and migrate
if [ "$RAILS_ENV" != "production" ]; then
  bundle exec rake db:create 2>/dev/null || true
fi

# Run database migrations
bundle exec rake db:migrate 2>/dev/null || echo "Migrations skipped or failed"

# Execute the main command
exec "$@"
