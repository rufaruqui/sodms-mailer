class CreateCargoReportsJob < ApplicationJob
  extend Resque::Plugins::Retry
  queue_as :saplmailer
  def perform(*args)
    # Enqueue report generation service
     CreateCargoReport.perform
  end
end
