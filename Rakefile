# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

 

# Require resque & resque-retry.
require 'resque-retry'

require 'resque/failure/redis'

# Require Rakefile related resque things.
require 'resque/tasks'
require 'resque/scheduler/tasks'


# Enable resque-retry failure backend.
Resque::Failure::MultipleWithRetrySuppression.classes = [Resque::Failure::Redis]
Resque::Failure.backend = Resque::Failure::MultipleWithRetrySuppression

# # Require jobs & application code.
# require 'jobs'

# desc 'Start the demo using `rackup`'
# task :start do 
#   exec 'rackup config.ru'
# end
