# SODMS Mailer - Deployment and Usage Guide

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Automated Deployment](#automated-deployment)
- [Manual Deployment](#manual-deployment)
- [Post-Deployment Configuration](#post-deployment-configuration)
- [Service Management](#service-management)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)

## Overview

SODMS Mailer is a Ruby on Rails application that handles email delivery and scheduling. This guide covers deployment on Ubuntu 16.04 (Xenial) servers.

**Architecture Components:**
- Web Server: Puma (4 workers)
- Background Jobs: Resque
- Job Scheduler: Resque Scheduler
- Database: PostgreSQL
- Cache/Queue: Redis
- Ruby Version: 2.3.3
- Deployment Tool: Capistrano

## Prerequisites

### Server Requirements
- Ubuntu 16.04 (Xenial) or compatible Linux distribution
- Minimum 2GB RAM
- Root or sudo access
- Static IP address or domain name

### Local Requirements
- SSH access to the server
- Git repository access (Bitbucket)
- Capistrano configured locally

## Automated Deployment

### Quick Start

1. **Download the deployment script:**
   ```bash
   wget https://path-to-repo/deploy_ubuntu16.sh
   chmod +x deploy_ubuntu16.sh
   ```

2. **Run the deployment script:**
   ```bash
   ./deploy_ubuntu16.sh
   ```

   The script will automatically:
   - Update system packages
   - Install RVM and Ruby 2.3.3
   - Install Node.js
   - Create deployment user (`mailer`)
   - Install PostgreSQL and create database
   - Install Redis
   - Create systemd services
   - Setup cron jobs

3. **Configuration Variables:**

   Edit these variables in `deploy_ubuntu16.sh` if needed:
   ```bash
   DEPLOY_USER="mailer"          # Deployment user
   DEPLOY_PASSWORD="1234@sodms"  # User password (change in production!)
   APP_DIR="/var/www/sodmsmailer"
   DB_PASSWORD="1234@mailer"     # Database password (change in production!)
   RUBY_VERSION="ruby-2.3.3"
   GEMSET_NAME="sodmsmailer"
   ```

## Manual Deployment

### Step 1: System Update and Dependencies

```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y curl gnupg build-essential dirmngr git apt-transport-https ca-certificates nodejs
sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
```

### Step 2: Install RVM and Ruby

```bash
# Import GPG keys
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg --import -

# Install RVM
curl -sSL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`

# Reload shell or run:
source /usr/local/rvm/scripts/rvm

# Install Ruby and Bundler
rvm install ruby-2.3.3
rvm --default use ruby-2.3.3
gem install bundler -v 1.17.3 --no-rdoc --no-ri
```

### Step 3: Create Deployment User

```bash
sudo adduser --disabled-password --gecos "" mailer
echo "mailer:1234@sodms" | sudo chpasswd

# Setup SSH keys
sudo mkdir -p ~mailer/.ssh
sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~mailer/.ssh/authorized_keys"
sudo chown -R mailer: ~mailer/.ssh
sudo chmod 700 ~mailer/.ssh
sudo chmod 600 ~mailer/.ssh/*
```

### Step 4: Install PostgreSQL

```bash
sudo apt-get install -y postgresql postgresql-contrib libpq-dev

# Create database and user
sudo -u postgres psql -c "CREATE USER mailer WITH PASSWORD '1234@mailer';"
sudo -u postgres psql -c "CREATE DATABASE mailer OWNER mailer;"
```

### Step 5: Install Redis

```bash
sudo apt-get install -y redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server
```

### Step 6: Setup Application Directory

```bash
sudo mkdir -p /var/www/sodmsmailer/shared/config
sudo mkdir -p /var/www/sodmsmailer/shared/log
sudo chown -R mailer: /var/www/sodmsmailer

# Create RVM gemset directory
sudo mkdir -p /usr/local/rvm/gems/ruby-2.3.3@sodmsmailer
sudo chown -R mailer: /usr/local/rvm/gems/ruby-2.3.3@sodmsmailer
```

### Step 7: Create Systemd Services

Create three service files in `/etc/systemd/system/`:

**sodmsmailer-web.service:**
```ini
[Unit]
Description=SODMS Mailer Web Service
After=network.target
StopWhenUnneeded=true

[Service]
User=mailer
WorkingDirectory=/var/www/sodmsmailer/current
Environment=PORT=7000
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && bundle exec puma -S ~/puma -C config/puma.rb >> /var/www/sodmsmailer/shared/log/production.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
```

**sodmsmailer-worker.service:**
```ini
[Unit]
Description=SODMS Mailer Worker Service
After=network.target redis-server.service
StopWhenUnneeded=true

[Service]
User=mailer
WorkingDirectory=/var/www/sodmsmailer/current
Environment=QUEUE=saplmailer
Environment=RAILS_ENV=production
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && bundle exec rake environment resque:work >> /var/www/sodmsmailer/shared/log/worker.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
```

**sodmsmailer-scheduler.service:**
```ini
[Unit]
Description=SODMS Mailer Scheduler Service
After=network.target redis-server.service
StopWhenUnneeded=true

[Service]
User=mailer
WorkingDirectory=/var/www/sodmsmailer/current
Environment=RAILS_ENV=production
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && bundle exec rake resque:scheduler >> /var/www/sodmsmailer/shared/log/scheduler.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
```

Enable services:
```bash
sudo systemctl daemon-reload
sudo systemctl enable sodmsmailer-web.service
sudo systemctl enable sodmsmailer-worker.service
sudo systemctl enable sodmsmailer-scheduler.service
```

### Step 8: Setup Cron Jobs

Switch to the mailer user and add cron jobs:

```bash
sudo -u mailer crontab -e
```

Add the following entries:
```cron
40 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake prepare_container_reports --silent'
45 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake send_container_reports --silent'
50 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
15 9 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
30 9 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
15 10 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
0 18 * * * find /var/www/sodmsmailer/releases/*/reports/* -mtime +30 -type f -delete
```

## Post-Deployment Configuration

### 1. Setup SSH Key for Git Access

```bash
sudo -u mailer ssh-keygen -t rsa -b 4096
sudo -u mailer cat ~mailer/.ssh/id_rsa.pub
```

Add the public key to your Bitbucket repository's deployment keys.

### 2. Configure Database

Create `/var/www/sodmsmailer/shared/config/database.yml`:

```yaml
production:
  adapter: postgresql
  encoding: unicode
  database: mailer
  pool: 5
  username: mailer
  password: 1234@mailer
  host: localhost
```

Set permissions:
```bash
sudo chmod 600 /var/www/sodmsmailer/shared/config/database.yml
sudo chown mailer: /var/www/sodmsmailer/shared/config/database.yml
```

### 3. Configure Secrets

Create `/var/www/sodmsmailer/shared/config/secrets.yml`:

```yaml
production:
  secret_key_base: <generate using 'rake secret'>
```

Set permissions:
```bash
sudo chmod 600 /var/www/sodmsmailer/shared/config/secrets.yml
sudo chown mailer: /var/www/sodmsmailer/shared/config/secrets.yml
```

### 4. Deploy Application

From your local machine:

```bash
bundle exec cap production deploy
```

### 5. Start Services

On the server:

```bash
sudo systemctl start sodmsmailer-web.service
sudo systemctl start sodmsmailer-worker.service
sudo systemctl start sodmsmailer-scheduler.service
```

## Service Management

### Check Service Status

```bash
sudo systemctl status sodmsmailer-web.service
sudo systemctl status sodmsmailer-worker.service
sudo systemctl status sodmsmailer-scheduler.service
```

### View Logs

```bash
# Application logs
sudo tail -f /var/www/sodmsmailer/shared/log/production.log

# Worker logs (Resque)
sudo tail -f /var/www/sodmsmailer/shared/log/worker.log

# Scheduler logs (Resque Scheduler)
sudo tail -f /var/www/sodmsmailer/shared/log/scheduler.log

# System journal logs
sudo journalctl -u sodmsmailer-web.service -f
sudo journalctl -u sodmsmailer-worker.service -f
sudo journalctl -u sodmsmailer-scheduler.service -f
```

### Restart Services

```bash
sudo systemctl restart sodmsmailer-web.service
sudo systemctl restart sodmsmailer-worker.service
sudo systemctl restart sodmsmailer-scheduler.service
```

### Stop Services

```bash
sudo systemctl stop sodmsmailer-web.service
sudo systemctl stop sodmsmailer-worker.service
sudo systemctl stop sodmsmailer-scheduler.service
```

## Usage

### Accessing the Application

The application runs on port 7000 by default:
```
http://your-server-ip:7000
```

### Database Access

```bash
sudo -u mailer psql mailer
```

### Rails Console

```bash
cd /var/www/sodmsmailer/current
sudo -u mailer bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && bundle exec rails console production'
```

### Running Rake Tasks

```bash
cd /var/www/sodmsmailer/current
sudo -u mailer bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && RAILS_ENV=production bundle exec rake TASK_NAME'
```

### Manual Job Execution

```bash
# Prepare container reports
sudo -u mailer bash -lc 'cd /var/www/sodmsmailer/current && source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && RAILS_ENV=production bundle exec rake prepare_container_reports'

# Send container reports
sudo -u mailer bash -lc 'cd /var/www/sodmsmailer/current && source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && RAILS_ENV=production bundle exec rake send_container_reports'

# Check undelivered emails
sudo -u mailer bash -lc 'cd /var/www/sodmsmailer/current && source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && RAILS_ENV=production bundle exec rake check_undelivered_emails'
```

## Troubleshooting

### Service Won't Start

1. **Check service status and logs:**
   ```bash
   sudo systemctl status sodmsmailer-web.service
   sudo journalctl -u sodmsmailer-web.service -n 100 --no-pager
   ```

2. **Verify RVM environment:**
   ```bash
   sudo -u mailer bash -lc 'source /usr/local/rvm/scripts/rvm && rvm list'
   ```

3. **Check for port conflicts:**
   ```bash
   sudo lsof -i :7000
   ```

4. **Kill stuck processes:**
   ```bash
   sudo pkill -9 -f puma
   sudo pkill -9 -f resque
   sudo systemctl reset-failed sodmsmailer-web.service
   sudo systemctl start sodmsmailer-web.service
   ```

### Database Connection Issues

1. **Test PostgreSQL connection:**
   ```bash
   sudo -u mailer psql -h localhost -d mailer -U mailer
   ```

2. **Check PostgreSQL service:**
   ```bash
   sudo systemctl status postgresql
   ```

3. **Verify database.yml permissions:**
   ```bash
   ls -la /var/www/sodmsmailer/shared/config/database.yml
   ```

### Redis Connection Issues

```bash
# Check Redis status
sudo systemctl status redis-server

# Test Redis connection
redis-cli ping
```

### Deployment Failures

1. **Check Capistrano output for errors**

2. **Verify SSH key is added to Bitbucket**

3. **Check file permissions:**
   ```bash
   sudo chown -R mailer: /var/www/sodmsmailer
   ```

4. **Verify bundle install:**
   ```bash
   cd /var/www/sodmsmailer/current
   sudo -u mailer bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ruby-2.3.3@sodmsmailer && bundle install'
   ```

### RVM PATH Issues

If commands aren't found, ensure RVM is sourced:

```bash
echo 'source /usr/local/rvm/scripts/rvm' >> ~/.bashrc
source ~/.bashrc
```

### Common Error Messages

**"Bundle: command not found"**
```bash
gem install bundler -v 1.17.3 --no-rdoc --no-ri
```

**"Rails: command not found"**
```bash
cd /var/www/sodmsmailer/current
bundle install
```

**"Permission denied" errors**
```bash
sudo chown -R mailer: /var/www/sodmsmailer
sudo chown -R mailer: /usr/local/rvm/gems/ruby-2.3.3@sodmsmailer
```

**"start-limit-hit" error**
```bash
sudo systemctl reset-failed sodmsmailer-web.service
sudo journalctl -u sodmsmailer-web.service -n 50
# Fix the underlying issue, then start again
```

## Security Recommendations

1. **Change default passwords** in production:
   - User password: `1234@sodms`
   - Database password: `1234@mailer`

2. **Configure firewall:**
   ```bash
   sudo ufw allow 7000/tcp
   sudo ufw allow 22/tcp
   sudo ufw enable
   ```

3. **Setup SSL/TLS** with a reverse proxy (nginx/Apache)

4. **Regular backups:**
   ```bash
   # Database backup
   sudo -u mailer pg_dump mailer > backup_$(date +%Y%m%d).sql
   ```

5. **Keep system updated:**
   ```bash
   sudo apt-get update && sudo apt-get upgrade -y
   ```

## Maintenance

### Log Rotation

Logs are automatically cleaned by cron:
- Old reports deleted after 30 days (runs daily at 6 PM)

### Database Maintenance

```bash
# Vacuum database
sudo -u mailer psql mailer -c "VACUUM ANALYZE;"

# Reindex
sudo -u mailer psql mailer -c "REINDEX DATABASE mailer;"
```

### Application Updates

```bash
# From local machine
bundle exec cap production deploy

# On server
sudo systemctl restart sodmsmailer-web.service
sudo systemctl restart sodmsmailer-worker.service
sudo systemctl restart sodmsmailer-scheduler.service
```

## Support

For issues or questions:
1. Check application logs
2. Check system journal: `sudo journalctl -xe`
3. Review this documentation
4. Contact the development team
