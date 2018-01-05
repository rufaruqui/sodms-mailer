class GenReport
   def self.perform(options={})
    
     ########  Retrive Stock Data from Sodms Backend ##########
     stockinfo = RetrieveStockInfo.perform
    
    
     ########  Generate Excel Sheet                  ##########
    options = Hash.new
    options[:stockinfo] = stockinfo
    options[:filename]  = 'stockreport'+Time.now.to_s+'.xlsx'
    GenStockReportXls.perform(options)
    
    
    ########  Send mail with excel reports as attacment######
    ReportMailer.daily_email_update(options).deliver
   end

end