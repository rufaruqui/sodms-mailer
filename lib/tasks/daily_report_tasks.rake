# # Require jobs & application code.
# require 'jobs'
 
#require 'jobs'

desc 'Prepare daily cargo reports'
task prepare_cargo_reports: :environment do   
    CreateCargoReportsJob.perform_later
end


desc 'Prepare daily containers reports'
task prepare_container_reports: :environment do   
    CreateContainerReportsJob.perform_later
end
 
desc 'Send daily containers reports'
task send_container_reports: :environment do   
    SendContainerReportsJob.perform_later
end


desc 'Check undelivered containers reports'
task check_undelivered_emails: :environment do   
    CheckUndeliveredEmailsJob.perform_later
end

desc 'Setting dynamic schchedule'
task set_schedule_dym: :environment do   
     SetSchedule.set_create_containers_reports
     SetSchedule.set_send_containers_reports
end

