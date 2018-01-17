class SendMorningReportsJob < ApplicationJob
  extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(*args)
    # Enqueue report generation service
     GenReport.perform
  end
end
