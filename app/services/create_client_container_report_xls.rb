require 'axlsx'

class CreateClientContainerReportXls < CreateExcelTemplate
    
   def self.perform(options={}) 
    puts "Creating Client Container Movement Report"
    # container_in = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Issue Date", "In Date", "Container Condition","Damage Area", "Damage Part", "Damage Description", "Unstuffing Date", "Out Date", "Seal Number", "Amended Seal No", "Vessel", "Rotation #", "Line #", "BE #", "BL #", "Location - From", "Depo Loc", "Importer", "CNF", "EIR #", "Commodity", "In Transport", "In Trailer", "In Remarks"]
    # container_in_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    # container_unstuffing = ["ID", "Container Number", "Size", "Type","Height", "Company", "Agent", "MLO", "Vessel", "Rotation #", "BE #", "BL #", "Line #", "Importer", "CNF", "EIR #", "Commodity","Seal Number", "Amended Seal No",  "Location - From", "Depo Loc","Issue Date", "In Date", "Unstuffing Date", "Container Condition","Damage Area", "Damage Part", "Damage Description","In Transport", "In Trailer", "Trailer #", "In Remarks"]
    # container_unstuffing_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    # container_fclout = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Vessel", "Rotation #", "Importer", "CNF" "Commodity","Current Depo", "Seal Number", "Amended Seal No","EIR #", "BE #", "BL #", "Line #",  "Location - From", "Depo Loc","Issue Date", "In Date", "Out Date","Out Location", "Container Condition","Damage Area", "Damage Part", "Damage Description","Total Lot", "Total Weight", "Out Transport", "Out Remarks"]
    # container_fclout_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    # container_ladenstock = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Vessel", "Rotation #", "Importer", "Container Condition","Damage Area", "Damage Part", "Damage Description","CNF", "Commodity","Seal Number", "Amended Seal No", "EIR #", "Issue Date", "In Date","Location - From", "Depo Loc","BE #", "BL #", "Line #","Trailer #","In Transport", "In Remarks"]
    # container_ladenstock_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
    

      Axlsx::Package.new do |p|
        wb = p.workbook
          wb.styles do |s| 
              heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                              :border => { :style => :thin, :color => "00" },
                              :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => true}
             date_format = s.add_style :format_code => 'YYYY-MM-DD'
  
          header = {:heading=>heading, :date_format=> date_format}
          wb.add_worksheet(:name => "In Report") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "In Report"
              prepare_workbook sheet, options[:containerinfo][:containerInReport], header    
            end
          
          wb.add_worksheet(:name => "In Report Summary") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "In Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerInReportSummary], header, false
            end
            
            wb.add_worksheet(:name => "Out Empty Report") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Out Empty Report"
              prepare_workbook sheet, options[:containerinfo][:containerEmptyOutReport], header    
            end

            wb.add_worksheet(:name => "Out Empty Report Summary") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Out Empty Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerEmptyOutReportSummary], header, false 
            end
          
          wb.add_worksheet(:name => "Out Laden Report") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Out Laden Report"
              prepare_workbook sheet, options[:containerinfo][:containerLadenOutReport], header  
            end
          
          wb.add_worksheet(:name => "Out Laden Report Summary") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Out Laden Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerLadenOutReportSummary], header,false
            end

      

          wb.add_worksheet(:name => "Stock Report") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Stock Report"
              prepare_workbook sheet, options[:containerinfo][:containerStockReport], header  
            end

          wb.add_worksheet(:name => "Stock Report Summary") do |sheet|
              add_header options[:permitted_depo_name], options[:client_name], sheet, header, "Stock Report Summary"
              prepare_workbook sheet, options[:containerinfo][:containerStockReportSummary], header, false 
          end
        end
          
          p.serialize(options[:filename])

          Rails.logger.info "########  Storing mail info at db ######" 
          EmailService.create_email options
      end
      
  end   
end


  