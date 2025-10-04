web: bundle exec puma -S ~/puma -C config/puma.rb
worker: bundle exec rake environment resque:work RAILS_ENV=production QUEUE=saplmailer
scheduler:bundle exec rake resque:scheduler RAILS_ENV=production


# RAILS_ENV=production bundle exec puma -S ~/puma -C config/puma.rb
# RAILS_ENV=production bundle exec rake environment resque:work RAILS_ENV=production QUEUE=saplmailer
# RAILS_ENV=production bundle exec rake resque:scheduler RAILS_ENV=production
# ExecStart=/bin/bash -lc 'rvm use 2.3.3 &&  bundle exec rake resque:scheduler'