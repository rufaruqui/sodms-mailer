class CreateContainerReport
    def self.perform(options={})  
        CreateEmptyContainerReport.perform
        CreateImportContainerReport.perform 
        true
    end
end