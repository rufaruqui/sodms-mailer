 
class GenReport

  def self.perform(options={})  
    
    Rails.logger.info '########  Retrive Stock Data from Sodms Backend ##########'
    puts '########  Retrive Stock Data from Sodms Backend ##########'

    stockinfo = RetrieveStockInfo.perform
    
    Rails.logger.info '########  Generate Excel Sheet                  ##########'
    puts '########  Generate Excel Sheet                  ##########'
    options = Hash.new
    options[:stockinfo] = stockinfo
    options[:filename]  = 'stockreport'+Time.now.to_s+'.xlsx'
    GenStockReportXls.perform(options)
    
    Rails.logger.info '########  Send mail with excel reports as attacment######'
    puts '########  Send mail with excel reports as attacment######'

    Rails.logger.info Time.now
    
    ReportMailer.daily_email_update(options)
  end

end