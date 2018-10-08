require 'axlsx'

class CreateClientContainerReportXls < CreateExcelTemplate
    
   def self.perform(options={}) 

    container_in = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Issue Date", "In Date", "Container Condition","Damage Area", "Damage Part", "Damage Description", "Unstuffing Date", "Out Date", "Seal Number", "Amended Seal No", "Vessel", "Rotation #", "Line #", "BE #", "BL #", "Location - From", "Depo Loc", "Importer", "CNF", "EIR #", "Commodity", "In Transport", "In Trailer", "In Remarks"]
    container_in_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    container_unstuffing = ["ID", "Container Number", "Size", "Type","Height", "Company", "Agent", "MLO", "Vessel", "Rotation #", "BE #", "BL #", "Line #", "Importer", "CNF", "EIR #", "Commodity","Seal Number", "Amended Seal No",  "Location - From", "Depo Loc","Issue Date", "In Date", "Unstuffing Date", "Container Condition","Damage Area", "Damage Part", "Damage Description","In Transport", "In Trailer", "Trailer #", "In Remarks"]
    container_unstuffing_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    container_fclout = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Vessel", "Rotation #", "Importer", "CNF" "Commodity","Current Depo", "Seal Number", "Amended Seal No","EIR #", "BE #", "BL #", "Line #",  "Location - From", "Depo Loc","Issue Date", "In Date", "Out Date","Out Location", "Container Condition","Damage Area", "Damage Part", "Damage Description","Total Lot", "Total Weight", "Out Transport", "Out Remarks"]
    container_fclout_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    container_ladenstock = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Vessel", "Rotation #", "Importer", "Container Condition","Damage Area", "Damage Part", "Damage Description","CNF", "Commodity","Seal Number", "Amended Seal No", "EIR #", "Issue Date", "In Date","Location - From", "Depo Loc","BE #", "BL #", "Line #","Trailer #","In Transport", "In Remarks"]
    container_ladenstock_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    

      Axlsx::Package.new do |p|
        wb = p.workbook
          wb.styles do |s| 
              heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                              :border => { :style => :thin, :color => "00" },
                              :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => false}
          header = s.add_style :bg_color => "FFFFFF", :fg_color => "000000", :b => true, :sz => 10, :border => { :style => :thin, :color => "000000" }     
          wb.add_worksheet(:name => "In Report") do |sheet|
              add_header sheet, heading, "In Report"
              prepare_workbook sheet, options[:containerinfo][:containerInReport], container_in, header    
            end
          
          wb.add_worksheet(:name => "In Report Summary") do |sheet|
              add_header sheet, heading, "In Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerInReportSummary], container_in_summary, header, false
            end
            
            wb.add_worksheet(:name => "Out Empty Report") do |sheet|
              add_header sheet, heading, "Out Empty Report"
              prepare_workbook sheet, options[:containerinfo][:containerEmptyOutReport], container_unstuffing, header    
            end

            wb.add_worksheet(:name => "Out Empty Report Summary") do |sheet|
              add_header sheet, heading, "Out Empty Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerEmptyOutReportSummary], container_unstuffing_summary, header, false 
            end
          
          wb.add_worksheet(:name => "Out Laden Report") do |sheet|
              add_header sheet, heading, "Out Laden Report"
              prepare_workbook sheet, options[:containerinfo][:containerLadenOutReport], container_fclout, header  
            end
          
          wb.add_worksheet(:name => "Out Laden Report Summary") do |sheet|
              add_header sheet, heading, "Out Laden Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerLadenOutReportSummary], container_fclout_summary, header,false
            end

      

          wb.add_worksheet(:name => "Stock Report") do |sheet|
              add_header sheet, heading, "Stock Report"
              prepare_workbook sheet, options[:containerinfo][:containerStockReport], container_ladenstock, header  
            end

          wb.add_worksheet(:name => "Stock Report Summary") do |sheet|
              add_header sheet, heading, "Stock Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerStockReportSummary], container_ladenstock_summary, header, false 
          end
        end
          
          p.serialize(options[:filename])

          Rails.logger.info "########  Storing mail info at db ######" 
          EmailService.create_email options
      end
      
  end 

    

     
end


  