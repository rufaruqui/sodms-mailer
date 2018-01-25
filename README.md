 Running mail Queue
    `QUEUE=* rake environment resque:work`
    `QUEUE=* rake environment resque:scheduler`
    

    /bin/bash -l -c  `cd /home/mailadmin/sodmsmailer && RAILS_ENV=production QUEUE=* bundle exec rake environment resque:work --silent`

    /bin/bash -l -c  `cd /home/mailadmin/sodmsmailer && RAILS_ENV=production QUEUE=* bundle exec rake environment resque:scheduler --silent` 
    

    web: bundle exec rails server -p $PORT


    6 Deploying a new release
You are now ready to deploy a new release using Capistrano!

On your local computer, make a random change in your application, add the various Capistrano config files, then commit and push your changes.

Copy$ nano app/somefile.rb
$ git add Capfile config/deploy.rb config/deploy lib/capistrano
$ git commit -a -m "Test Capistrano"
$ git push
Next, run Capistrano to start the deployment:

Copy$ bundle exec cap production deploy