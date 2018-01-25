web: bundle exec puma -e $RAILS_ENV -p 5000 -S ~/puma -C config/puma.rb
worker: QUEUE=* bundle exec rake environment resque:work
scheduler: bundle exec rake resque:scheduler