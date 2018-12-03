class SetSchedule
    def self.set_create_containers_reports(config={})  
        name="create_containers_report"
        config[:class] = 'CreateContainerReportsJob'  if config[:class].nil?
        config[:every] = ['1d', {at:  '6:30am'}] if config[:every].nil?
        #config[:every] = ['1d', {at: Scheduler.first.execution_time}] if config[:every].nil?
        config[:persist] = true
        config[:queue]='saplmailer' if config[:queue].nil?
        puts config 
        Resque.set_schedule(name, config)
    end

    def self.set_send_containers_reports(config={})  
        name="send_containers_reports"
        config[:class] = 'SendContainerReportsJob'  if config[:class].nil?
        config[:every] = ['1d', {at: '7am'}] if config[:every].nil?
        #config[:every] = ['1d', {at: Scheduler.first.execution_time}] if config[:every].nil?
        config[:persist] = true
        config[:queue]='saplmailer' if config[:queue].nil?
        puts config
        Resque.set_schedule(name, config)
    end

    def self.list_of_services
        Dir.glob('app/services/*.rb').map do |file|
            file[/app\/services\/(.*)\.rb/, 1].camelize
        end
    end

    def list_of_jobs
      list = Dir.glob('app/jobs/*.rb').map do |file|
            file[/app\/jobs\/(.*)\.rb/, 1].camelize
        end
      list -= ["ApplicationJob"]
    end
end
