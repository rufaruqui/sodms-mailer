 Running mail Queue
    `QUEUE=* rake environment resque:work`
    `QUEUE=* rake environment resque:scheduler`
    

    /bin/bash -l -c  `cd /home/mailadmin/sodmsmailer && RAILS_ENV=production QUEUE=* bundle exec rake environment resque:work --silent`

    /bin/bash -l -c  `cd /home/mailadmin/sodmsmailer && RAILS_ENV=production QUEUE=* bundle exec rake environment resque:scheduler --silent` 
    

    web: bundle exec rails server -p $PORT