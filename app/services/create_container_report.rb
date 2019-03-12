class CreateContainerReport
    def self.perform(options={})  
        CreateEmptyContainerReport.perform
        CreateImportContainerReport.perform 
    end
end