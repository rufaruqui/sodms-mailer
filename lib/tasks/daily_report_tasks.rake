# # Require jobs & application code.
# require 'jobs'
 
#require 'jobs'

desc 'prepare daily containers report in the morning'
task prepare_import_container_reports: :environment do   
    ContainerReportEmailJob.perform_later
end

desc 'send daily import containers report in the morning'
task send_import_container_reports: :environment do   
    SendEmailReport.perform
end


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
     SetSchedule.set_sent_containers_reports
     SetSchedule.set_create_conatainers_reports
end

