FROM ruby:2.3.3

# Fix Debian Jessie archived repositories
RUN echo "deb [trusted=yes] http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list && \
    echo "deb [trusted=yes] http://archive.debian.org/debian-security/ jessie/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99no-check-valid-until

# Install dependencies
RUN apt-get update -qq && apt-get install -y --allow-unauthenticated \
    build-essential \
    libpq-dev \
    nodejs \
    libmysqlclient-dev \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Create directories for reports and logs
RUN mkdir -p reports log tmp/pids tmp/cache tmp/sockets

# Add a script to be executed every time the container starts
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

# Expose port 3000
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
