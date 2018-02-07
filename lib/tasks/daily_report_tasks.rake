# # Require jobs & application code.
# require 'jobs'
 
#require 'jobs'

desc 'send daily reports in the morning'
task send_daily_reports: :environment do  
    #GenReport.perform.deliver_at(Time.now)
    SendMorningReportsJob.perform_later
end


desc 'send daily reports in the morning'
task send_test_mail: :environment do  
    #GenReport.perform.deliver_at(Time.now)
     SendTestMailJob.perform_later
end

desc 'Setting dynamic schchedule'
task set_schedule_dym: :environment do   
     SetSchedule.set_schedule_daily_reports
end

