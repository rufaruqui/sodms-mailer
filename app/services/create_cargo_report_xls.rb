require 'axlsx'

class CreateCargoReportXls < CreateExcelTemplate
    
   def self.perform(options={}) 
    puts "Creating Cargo Report"
 
      Axlsx::Package.new do |p|
        wb = p.workbook
          wb.styles do |s| 
              heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                              :border => { :style => :thin, :color => "00" },
                              :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => true}
             date_format = s.add_style :format_code => 'YYYY-MM-DD'
  
          header = {:heading=>heading, :date_format=> date_format}
          wb.add_worksheet(:name => "cargoBalanceData") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "cargoBalanceData"
              prepare_workbook sheet, options[:cargoinfo][:cargoBalanceData], header    
            end
          
          wb.add_worksheet(:name => "cargoReceivingData") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "cargoReceivingData"
              prepare_workbook sheet, options[:cargoinfo][:cargoReceivingData], header, false
            end
            
            wb.add_worksheet(:name => "cargoStuffingData") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "cargoStuffingData"
              prepare_workbook sheet, options[:cargoinfo][:cargoStuffingData], header    
            end

            wb.add_worksheet(:name => "cargoShutoutData") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "cargoShutoutData"
              prepare_workbook sheet, options[:cargoinfo][:cargoShutoutData], header, false 
            end
          
          wb.add_worksheet(:name => "buyerSealData") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "buyerSealData"
              prepare_workbook sheet, options[:cargoinfo][:buyerSealData], header  
            end
        end
          
          p.serialize(options[:filename])

          Rails.logger.info "########  Storing mail info at db ######" 
          EmailService.create_email options
      end
      
  end   
end


  