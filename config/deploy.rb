# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :application, "sodmsmailer"
#set :repo_url, "ssh://git@203.202.249.100:7999/sodms/sodmsmailer.git"
set :repo_url, "ssh://git@192.168.100.3:7999/sodms/sodmsmailer.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, "/var/www/sodmsmailer"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
 append :linked_files, "config/database.yml", "config/secrets.yml", "config/local_env.yml"

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

namespace :app do
  desc "Start SODMS Mailer"
  task :start do
    on roles(:web) do |host|
      within release_path do
       execute :sudo, :systemctl, :start, "sodmsmailer-web.service"
       execute :sudo, :systemctl, :start, "sodmsmailer-worker.service"
       execute :sudo, :systemctl, :start, "sodmsmailer-scheduler.service"
      end
    end
  end

  desc "Stop   SODMS Mailer"
  task :stop do
    on roles(:web) do |host|
      within release_path do
       execute :sudo, :systemctl, :stop, "sodmsmailer-web.service"
       execute :sudo, :systemctl, :stop, "sodmsmailer-worker.service"
       execute :sudo, :systemctl, :stop, "sodmsmailer-scheduler.service"
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
        #execute :sudo, :foreman, :export, :systemd, "/etc/systemd/system", "--user mailadmin"
        #execute :sudo, :systemctl, "daemon-reload"
      end
    end
  end
end

after 'deploy:publishing', 'app:restart'
#after 'app:systemd', 'app:restart'


