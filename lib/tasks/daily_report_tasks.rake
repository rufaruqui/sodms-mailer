desc 'send daily reports in the morning'
task send_daily_reports: :environment do 
    options = Hash.new
    ReportMailer.daily_email_update(options).deliver_in(7.days) 
end