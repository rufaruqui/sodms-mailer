class CreateContainerReportsJob < ApplicationJob
  extend Resque::Plugins::Retry
  queue_as :saplmailer
  def perform(*args)
    # Enqueue report generation service
     CreateContainerReport.perform
  end
end
