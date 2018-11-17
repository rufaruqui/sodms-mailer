class SetSchedule
    def self.set_create_conatainers_reports(config={})  
        name="create_containers_report"
        config[:class] = 'ContainerReportEmailJob'  if config[:class].nil?
        config[:every] = ['1d', {at:  '6:30am'}] if config[:every].nil?
        #config[:every] = ['1d', {at: Scheduler.first.execution_time}] if config[:every].nil?
        config[:persist] = true
        config[:queue]='saplmailer' if config[:queue].nil?
        puts config 
        Resque.set_schedule(name, config)
    end

    def self.set_sent_containers_reports(config={})  
        name="send_containers_reports"
        config[:class] = 'SendEmailReport'  if config[:class].nil?
        config[:every] = ['1d', {at: '7am'}] if config[:every].nil?
        #config[:every] = ['1d', {at: Scheduler.first.execution_time}] if config[:every].nil?
        config[:persist] = true
        config[:queue]='saplmailer' if config[:queue].nil?
        puts config
        Resque.set_schedule(name, config)
    end

    def self.set_schedule_daily_reports(config={})  
        name="sending_daily_update"
        config[:class] = 'SendMorningReportsJob'  if config[:class].nil?
        config[:every] = ['1d', {at: Scheduler.first.execution_time}] if config[:every].nil?
        config[:persist] = true
        config[:queue]='saplmailer' if config[:queue].nil?
        puts config
        Resque.set_schedule(name, config)
    end
end
