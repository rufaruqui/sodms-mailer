class SetSchedule
    def self.set_schedule_daily_reports(config={})
        name="sending_daily_update"
        config[:class] = 'SendMorningReportsJob'
        config[:args] = ''
        config[:every] = ['1d', {at: '3:30pm'}]
        config[:persist] = true
        config[:queue]='saplmailer'
        Resque.set_schedule(name, config)
    end
end
