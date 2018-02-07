class SendTestMailJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer
  def perform(*args)
    TestMailer.daily_email_update.deliver_at(Time.now)
  end
end
 