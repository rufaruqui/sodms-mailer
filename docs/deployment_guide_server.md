## Deployment Guide:
   Website: https://www.phusionpassenger.com/library/walkthroughs/deploy/
### Step 1: 
     Select Ruby
### Step 2:
    Select “Generic Linux/Unix deployment tutorial”
### Step 3:
   Select “Nginx” (https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/integration_mode.html#nginx_choices)
### Step 4: 
   Select Server: Choose open source https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/open_source_vs_enterprise.html#oss_choices
### Step 5: Install Ruby
```bash    
sudo apt-get update
sudo apt-get install -y curl gnupg build-essential
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ curl -sSL https://get.rvm.io | sudo bash -s stable
$ sudo usermod -a -G rvm `whoami`
$ rvm install ruby-2.3.3
$ rvm --default use ruby-2.3.3
$ gem install bundler --no-rdoc --no-ri
sudo apt-get install -y nodejs &&
sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
```
<!--
### Step 6: Install Passenger
```bash
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
```
--- Add our APT repository
```
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update
```

 ### Install Passenger + Nginx
`sudo apt-get install -y nginx-extras passenger`

Step 2: enable the Passenger Nginx module and restart Nginx
Edit /etc/nginx/nginx.conf and uncomment include /etc/nginx/passenger.conf;. For example, you may see this:
Copy# include /etc/nginx/passenger.conf;
Remove the '#' characters, like this:
Copyinclude /etc/nginx/passenger.conf;
If you don't see a commented version of include /etc/nginx/passenger.conf; inside nginx.conf, then you need to insert it yourself. Insert it into /etc/nginx/nginx.conf inside the http block. For example:
Copy...

http {
    include /etc/nginx/passenger.conf;
    ...
}
When you are finished with this step, restart Nginx:
Copy$ sudo service nginx restart -->

### Step 6: Deploy the app
https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/xenial/deploy_app.html

```bash
ssh shimul@175.29.189.243

sudo adduser mailer
sudo passwd mailer  
      Set Password 1234@sodms
ssh-keygen

sudo mkdir -p ~mailer/.ssh
touch $HOME/.ssh/authorized_keys
sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~mailer/.ssh/authorized_keys"
sudo chown -R mailer: ~mailadmin/.ssh
sudo chmod 700 ~mailer/.ssh
sudo sh -c "chmod 600 ~mailer/.ssh/*"
```
1.3 Install Git on the server
`sudo apt-get install -y git`


### Install PostGRESSQL 
    https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-16-04

``` 
sudo apt-get install postgresql postgresql-contrib
sudo -i -u postgres
createuser –interactive
      username mailer
```
To log in with ident based authentication, you'll need a Linux user with the same name as your Postgres role and database.
If you don't have a matching Linux user available, you can create one with the adduser command. You will have to do this from an account with sudo privileges (not logged in as the postgres user):
sudo mailer

```
Create user: mailer
Create db: mailer
Create pg role: mailer
sudo -u mailer psql mailer
```
```
ALTER USER mailer WITH PASSWORD '1234@mailer'
Password: 1234@mailer
```

Setting up a basic directory structure
```
sudo mkdir -p /var/www/sodmsmailer/shared
sudo chown mailer: /var/www/sodmsmailer/ /var/www/sodmsmailer/shared/
```

Create initial configuration files
```
sudo mkdir -p /var/www/sodmsmailer/shared/config
sudo chown -R mailer: /var/www/sodmsmailer/shared/config/
sudo chmod 600 /var/www/sodmsmailer/shared/config/database.yml
sudo chmod 600 /var/www/sodmsmailer/shared/config/secrets.yml
sudo mkdir -p /usr/local/rvm/gems/ruby-2.3.3@sodmsmailer
sudo chown -R mailer: /usr/local/rvm/gems/ruby-2.3.3@sodmsmailer
```


Add your Server’s SSH key to bitbucket


Deploy in all servers using following command
   `bundle exec cap production deploy`

Install pg gem on server
  `sudo apt-get install libpq-dev`



Create   /etc/system/system/
```
sodmsmailer-scheduler.service
sodmsmailer-web.service
sodmsmailer-worker.service
```

################## sodmsmailer-web.service##########
```
[Unit]
StopWhenUnneeded=true

[Service]
User=mailadmin
WorkingDirectory=/var/www/sodmsmailer/current
Environment=PORT=7000
ExecStart=/bin/bash -lc 'bundle exec puma -S ~/puma -C config/puma.rb'
Restart=always
StandardInput=null
StandardOutput=/var/www/sodmsmailer/shared/log/production.log
StandardError=/var/www/sodmsmailer/shared/log/production.log
SyslogIdentifier=%n
KillMode=process

[Install]
WantedBy=multi-user.target
```



#######################
sudo systemctl enable sodmsmailer-web.service
sudo systemctl start sodmsmailer-web.service
sudo systemctl status sodmsmailer-web.service

Do same things for all services.


Install Redis server for Mail Scheduling
 `https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04`



### Cronjob

```
40 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake prepare_container_reports  --silent'

45 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake send_container_reports  --silent'

50 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

15 9 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

30 09 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

15 10 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

0  18 * * *  find /var/www/sodmsmailer/releases/*/reports/* -mtime +30 -type f -delete
```