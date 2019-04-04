class SendTestMailJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer
  def perform(*args)
    TestMailer.perform
  end
end
 