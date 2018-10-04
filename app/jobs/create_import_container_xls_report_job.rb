class CreateImportContainerXlsReportJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(options={}) 
     CreateClientContainerReportXls.perform(options)
  end
end
