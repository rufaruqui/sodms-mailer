# # Require jobs & application code.
# require 'jobs'
 
#require 'jobs'

desc 'prepare daily containers reports'
task prepare_container_reports: :environment do   
    ContainerReportEmailJob.perform_later
end


 
desc 'send daily containers reports'
task send_container_reports: :environment do   
    SendEmailReportsJob.perform_later
end

 
 
desc 'Setting dynamic schchedule'
task set_schedule_dym: :environment do   
     SetSchedule.set_schedule_daily_reports
end

