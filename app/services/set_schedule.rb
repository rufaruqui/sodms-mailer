class SetSchedule
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
