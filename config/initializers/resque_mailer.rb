$redis = Redis.new(url: ENV["REDIS_URL"] || 'redis://127.0.0.1:6379')
Resque.redis = $redis
Resque.redis.namespace = 'rm'

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }

Resque::Mailer.default_queue_name = 'saplmailer'

Resque::Mailer.excluded_environments = [:test]

Resque::Mailer.error_handler = lambda { |mailer, message, error, action, args|
  # Necessary to re-enqueue jobs that receieve the SIGTERM signal
  if error.is_a?(Resque::TermException)
    Resque.enqueue(mailer, action, *args)
  else
    raise error
  end
  # raise error unless error.is_a?(Resque::TermException)
  #   Resque.enqueue(mailer, action, *args)
}