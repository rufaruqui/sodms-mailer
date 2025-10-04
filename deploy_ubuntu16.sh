#!/bin/bash
set -e

# SODMS Mailer Deployment Script for Ubuntu 16.04
# This script automates the deployment process based on deployment_guide_server.md

echo "======================================"
echo "SODMS Mailer Deployment Script"
echo "Ubuntu 16.04 (Xenial)"
echo "======================================"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration variables
DEPLOY_USER="mailer"
DEPLOY_PASSWORD="1234@sodms"
APP_DIR="/var/www/sodmsmailer"
DB_PASSWORD="1234@mailer"
RUBY_VERSION="ruby-2.3.3"
GEMSET_NAME="sodmsmailer"

echo_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Step 1: Update system
echo_info "Step 1: Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Step 2: Install basic dependencies
echo_info "Step 2: Installing basic dependencies..."
sudo apt-get install -y curl gnupg build-essential dirmngr git apt-transport-https ca-certificates

# Step 3: Install Node.js
echo_info "Step 3: Installing Node.js..."
sudo apt-get install -y nodejs
sudo ln -sf /usr/bin/nodejs /usr/local/bin/node

# Step 4: Install RVM and Ruby
echo_info "Step 4: Installing RVM and Ruby ${RUBY_VERSION}..."
echo_info "Importing RVM GPG keys..."
curl -sSL https://rvm.io/mpapis.asc | sudo gpg --import -
curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg --import -
curl -sSL https://get.rvm.io | sudo bash -s stable
sudo usermod -a -G rvm `whoami`

# Source RVM
source /usr/local/rvm/scripts/rvm

# Install Ruby
rvm install ${RUBY_VERSION}
rvm --default use ${RUBY_VERSION}

# Install Bundler (compatible version for Ruby 2.3.3)
gem install bundler -v 1.17.3 --no-rdoc --no-ri

# Add RVM and gem bin directories to PATH
echo 'source /usr/local/rvm/scripts/rvm' >> ~/.bashrc
echo 'export PATH="$PATH:$GEM_HOME/bin"' >> ~/.bashrc
source ~/.bashrc

# # Step 5: Create deployment user
# echo_info "Step 5: Creating deployment user '${DEPLOY_USER}'..."
# if id "${DEPLOY_USER}" &>/dev/null; then
#     echo_warn "User ${DEPLOY_USER} already exists, skipping..."
# else
#     sudo adduser --disabled-password --gecos "" ${DEPLOY_USER}
#     echo "${DEPLOY_USER}:${DEPLOY_PASSWORD}" | sudo chpasswd
# fi

# Step 6: Setup SSH for deployment user
echo_info "Step 6: Setting up SSH for deployment user..."
sudo mkdir -p ~${DEPLOY_USER}/.ssh
touch $HOME/.ssh/authorized_keys
sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~${DEPLOY_USER}/.ssh/authorized_keys"
sudo chown -R ${DEPLOY_USER}: ~${DEPLOY_USER}/.ssh
sudo chmod 700 ~${DEPLOY_USER}/.ssh
sudo sh -c "chmod 600 ~${DEPLOY_USER}/.ssh/*"

# Step 7: Install PostgreSQL
echo_info "Step 7: Installing PostgreSQL..."
sudo apt-get install -y postgresql postgresql-contrib libpq-dev

# Create PostgreSQL user and database
echo_info "Creating PostgreSQL database and user..."
sudo -u postgres psql -c "CREATE USER ${DEPLOY_USER} WITH PASSWORD '${DB_PASSWORD}';" || echo_warn "User may already exist"
sudo -u postgres psql -c "CREATE DATABASE ${DEPLOY_USER} OWNER ${DEPLOY_USER};" || echo_warn "Database may already exist"
sudo -u postgres psql -c "ALTER USER ${DEPLOY_USER} WITH PASSWORD '${DB_PASSWORD}';"

# Step 8: Setup application directory structure
echo_info "Step 8: Setting up application directory structure..."
sudo mkdir -p ${APP_DIR}/shared/config
sudo mkdir -p ${APP_DIR}/shared/log
sudo chown -R ${DEPLOY_USER}: ${APP_DIR}

# Set permissions for config files
sudo chmod 600 ${APP_DIR}/shared/config/* 2>/dev/null || true

# Create RVM gemset directory
echo_info "Creating RVM gemset directory..."
sudo mkdir -p /usr/local/rvm/gems/${RUBY_VERSION}@${GEMSET_NAME}
sudo chown -R ${DEPLOY_USER}: /usr/local/rvm/gems/${RUBY_VERSION}@${GEMSET_NAME}

# Step 9: Install Redis
echo_info "Step 9: Installing Redis..."
sudo apt-get install -y redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server

# Step 10: Create systemd service files
echo_info "Step 10: Creating systemd service files..."

# Web service
sudo tee /etc/systemd/system/sodmsmailer-web.service > /dev/null <<EOF
[Unit]
Description=SODMS Mailer Web Service
After=network.target
StopWhenUnneeded=true

[Service]
User=${DEPLOY_USER}
WorkingDirectory=${APP_DIR}/current
Environment=PORT=7000
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ${RUBY_VERSION}@${GEMSET_NAME} && bundle exec puma -S ~/puma -C config/puma.rb >> ${APP_DIR}/shared/log/production.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Worker service
sudo tee /etc/systemd/system/sodmsmailer-worker.service > /dev/null <<EOF
[Unit]
Description=SODMS Mailer Worker Service
After=network.target redis-server.service
StopWhenUnneeded=true

[Service]
User=${DEPLOY_USER}
WorkingDirectory=${APP_DIR}/current
Environment=QUEUE=saplmailer
Environment=RAILS_ENV=production
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ${RUBY_VERSION}@${GEMSET_NAME} && bundle exec rake environment resque:work >> ${APP_DIR}/shared/log/worker.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Scheduler service
sudo tee /etc/systemd/system/sodmsmailer-scheduler.service > /dev/null <<EOF
[Unit]
Description=SODMS Mailer Scheduler Service
After=network.target redis-server.service
StopWhenUnneeded=true

[Service]
User=${DEPLOY_USER}
WorkingDirectory=${APP_DIR}/current
Environment=RAILS_ENV=production
ExecStart=/bin/bash -lc 'source /usr/local/rvm/scripts/rvm && rvm use ${RUBY_VERSION}@${GEMSET_NAME} && bundle exec rake resque:scheduler >> ${APP_DIR}/shared/log/scheduler.log 2>&1'
Restart=always
StandardInput=null
StandardOutput=journal
StandardError=journal
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Enable services (but don't start them yet - app needs to be deployed first)
sudo systemctl enable sodmsmailer-web.service
sudo systemctl enable sodmsmailer-worker.service
sudo systemctl enable sodmsmailer-scheduler.service

# Step 11: Setup crontab for deployment user
echo_info "Step 11: Setting up crontab..."
sudo -u ${DEPLOY_USER} bash -c "crontab -l > /tmp/mailer_cron 2>/dev/null || true"
sudo -u ${DEPLOY_USER} bash -c "cat >> /tmp/mailer_cron" <<EOF
40 8 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake prepare_container_reports --silent'
45 8 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake send_container_reports --silent'
50 8 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
15 9 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
30 9 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
15 10 * * * /bin/bash -l -c 'cd ${APP_DIR}/current && /usr/local/rvm/bin/rvm-exec ${RUBY_VERSION} && RAILS_ENV=production bundle exec rake check_undelivered_emails --silent'
0 18 * * * find ${APP_DIR}/releases/*/reports/* -mtime +30 -type f -delete
EOF
sudo -u ${DEPLOY_USER} crontab /tmp/mailer_cron
rm /tmp/mailer_cron

echo ""
echo_info "======================================"
echo_info "Deployment script completed!"
echo_info "======================================"
echo ""
echo_info "Next steps:"
echo "1. Add your server's SSH key to Bitbucket:"
echo "   sudo -u ${DEPLOY_USER} ssh-keygen -t rsa -b 4096"
echo "   sudo -u ${DEPLOY_USER} cat ~${DEPLOY_USER}/.ssh/id_rsa.pub"
echo ""
echo "2. Create and configure database.yml in ${APP_DIR}/shared/config/"
echo ""
echo "3. Create and configure secrets.yml in ${APP_DIR}/shared/config/"
echo ""
echo "4. Deploy the application:"
echo "   bundle exec cap production deploy"
echo ""
echo "5. Start the services:"
echo "   sudo systemctl start sodmsmailer-web.service"
echo "   sudo systemctl start sodmsmailer-worker.service"
echo "   sudo systemctl start sodmsmailer-scheduler.service"
echo ""
echo_info "Database credentials:"
echo "   User: ${DEPLOY_USER}"
echo "   Password: ${DB_PASSWORD}"
echo "   Database: ${DEPLOY_USER}"
echo ""
echo_warn "Please change default passwords in production!"
