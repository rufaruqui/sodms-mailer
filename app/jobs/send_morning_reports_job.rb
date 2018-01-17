class SendMorningReportsJob < ApplicationJob
  extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(*args)
    # Do something later
     GenReport.perform
  end
end
