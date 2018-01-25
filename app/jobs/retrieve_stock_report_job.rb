class RetrieveStockReportJob < ApplicationJob
   extend Resque::Plugins::Retry
 

  queue_as :saplmailer

  def perform(options={})
    # Do something later
     
      stockinfo = RetrieveStockInfo.perform(options)
        puts stockinfo

      if !stockinfo.blank?
          if recipents.blank? or recipents.nil?
            Rails.logger.info '######## No Recipents  ##########'
            puts '########## No Recipents ##########'
          else

            Rails.logger.info '########  Generate Excel Sheet                  ##########'
            puts '########  Generate Excel Sheet                  ##########'
            
            options[:stockinfo] = stockinfo
            options[:recipents] = recipents
            options[:filename]  = './reports/'+'stockreport'+Time.now.to_s+'.xlsx'
            GenStockReportXls.perform(options)
            
            Rails.logger.info '########  Send mail with excel reports as attacment######'
            puts '########  Send mail with excel reports as attacment######'

            Rails.logger.info Time.now
            
          #  options = Hash.new
          #  options[:recipents]="rufaruqui@gmail.com;"
          #  options[:filename]="simple.xlsx"
           #EnqueueEmailJob.perform_later(options);
           ReportMailer.daily_email_update(options).deliver_at(Time.now)
          # ReportMailer.daily_email_update(options).deliver_at(Time.now)
          end  
        end    
  end
end
