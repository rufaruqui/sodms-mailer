web: bundle exec puma -S ~/puma -C config/puma.rb
worker: bundle exec rake environment resque:work RAILS_ENV=production QUEUE=saplmailer
scheduler:bundle exec rake resque:scheduler RAILS_ENV=production