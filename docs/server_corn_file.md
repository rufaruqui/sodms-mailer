## Preparing and sending email reports

```bash
40 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake prepare_container_reports  --silent'

45 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake send_container_reports  --silent'

50 8 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

15 9 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

30 09 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

15 10 * * * /bin/bash -l -c 'cd /var/www/sodmsmailer/current && /usr/local/rvm/bin/rvm-exec ruby-2.3.3 && RAILS_ENV=production bundle exec rake check_undelivered_emails  --silent'

```

## Deleteing all reports older than 30 days, run every day at 6 pm

```bash
0  18 * 8 *  find /var/www/sodmsmailer/releases/*/reports/* -mtime +30 -type f -delete
```