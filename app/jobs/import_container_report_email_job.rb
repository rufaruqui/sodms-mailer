class ImportContainerReportEmailJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(*args)
    # Enqueue report generation service
     CreateImportContainerReportEmail.perform
  end
end
