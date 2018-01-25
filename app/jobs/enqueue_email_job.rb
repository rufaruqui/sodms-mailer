class EnqueueEmailJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(optinost={}) 
    ReportMailer.daily_email_update(options).deliver_later
  end
end
