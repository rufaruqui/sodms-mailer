# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "sodmsmailer"
set :repo_url, "ssh://git@203.202.249.101:7999/sod/sodmsmailer.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/var/www/sodmsmailer/code"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
 append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
 append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

 set :rvm_ruby_version, '2.3.3'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :app_name, "sodmsmailer"
set :user, "mailadmin"

# namespace :foreman do
#   desc "Export the Procfile to Ubuntu's upstart scripts"
#   task :export do
#     on roles(:app) do
#     run "cd #{current_path} && #{sudo} foreman export upstart /etc/init -a #{app_name} -u #{user} -l /var/www/#{app_name}/log"
#   end
# end 

#   desc "Start the application services"
#   task :start do
#     on roles(:app) do
#     run "#{sudo} service #{app_name} start"
#   end
# end

#   desc "Stop the application services"
#   task :stop do
#     on roles(:app) do
#     run "#{sudo} service #{app_name} stop"
#   end
# end

#   desc "Restart the application services"
#   task :restart do
#     on roles(:app) do
#     run "#{sudo} service #{app_name} start || #{sudo} service #{app_name} restart"
#   end
# end 
# end

# namespace :deploy do

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#       foreman.export

#     # on OS X the equivalent pid-finding command is `ps | grep '/puma' | head -n 1 | awk {'print $1'}`
#     run "(kill -s SIGUSR1 $(ps -C ruby -F | grep '/puma' | awk {'print $2'})) || #{sudo} service #{app_name} restart"

#     # foreman.restart # uncomment this (and comment line above) if we need to read changes to the procfile

#     end
#   end
# end

namespace :app do
  desc "Start SODMS Mailer"
  task :start do
    on roles(:web) do |host|
      within release_path do
        execute :sudo, :systemctl, :start, "sodms-mailerweb@7070.service"
        execute :sudo, :systemctl, :start, "sodms-mailerworker@7071.service"
        execute :sudo, :systemctl, :start, "sodms-mailerscheduler@7072.service"
      end
    end
  end

  desc "Stop   SODMS Mailer"
  task :stop do
    on roles(:web) do |host|
      within release_path do
        execute :sudo, :systemctl, :stop, "sodmsmailer-web@7070.service"
        execute :sudo, :systemctl, :stop, "sodmsmailer-worker@7071.service"
        execute :sudo, :systemctl, :stop, "sodmsmailer-scheduler@7072.service"
      end
    end
  end

  desc "Restart   SODMS Mailer"
  task :restart do
    on roles(:web) do |host|
      within release_path do
        execute :sudo, :systemctl, :restart, "sodmsmailer-web.service"
        execute :sudo, :systemctl, :restart, "sodmsmailer-worker.service"
        execute :sudo, :systemctl, :restart, "sodmsmailer-scheduler.service"
      end
    end
  end

  desc "Reload systemd"
  task :systemd do
    on roles(:web) do
      within release_path do
        execute :sudo, :foreman, :export, :systemd, "/etc/systemd/system", "--user mailadmin"
        execute :sudo, :systemctl, "daemon-reload"
      end
    end
  end
end

after 'deploy:publishing', 'app:systemd'
after 'app:systemd', 'app:restart'


