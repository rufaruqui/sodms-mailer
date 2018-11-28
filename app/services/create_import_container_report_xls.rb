
require 'axlsx'

class CreateImportContainerReportXls < CreateExcelTemplate
   
   def self.perform(options={}) 
    puts "Creating Import Container Movement Report"
   import_in = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Issue Date", "In Date", "Container Condition","Damage Area", "Damage Part", "Damage Description", "Unstuffing Date", "Out Date", "Seal Number", "Amended Seal No", "Vessel", "Rotation #", "Line #", "BE #", "BL #", "Location - From", "Depo Loc", "Importer", "CNF", "EIR #", "Commodity", "In Transport", "In Trailer", "In Remarks"]
   import_in_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
   import_unstuffing = ["ID", "Container Number", "Size", "Type","Height", "Company", "Agent", "MLO", "Import Vessel", "Rotation #", "BE #", "BL #", "Line #", "Importer", "CNF", "EIR #", "Commodity","Seal Number", "Amended Seal No",  "Location - From", "Depo Loc","Issue Date", "In Date", "Unstuffing Date", "Container Condition","Damage Area", "Damage Part", "Damage Description","In Transport", "In Trailer", "Trailer #", "In Remarks"]
   import_unstuffing_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
   import_fclout = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Import Vessel", "Rotation #", "Importer", "CNF" "Commodity","Current Depo", "Seal Number", "Amended Seal No","EIR #", "BE #", "BL #", "Line #",  "Location - From", "Depo Loc","Issue Date", "In Date", "Out Date","Out Location", "Container Condition","Damage Area", "Damage Part", "Damage Description","Total Lot", "Total Weight", "Out Transport", "Out Remarks"]
   import_fclout_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
   import_ladenstock = ["ID", "Container Number", "Size", "Type", "Company", "Agent", "MLO", "Import Vessel", "Rotation #", "Importer", "Container Condition","Damage Area", "Damage Part", "Damage Description","CNF", "Commodity","Seal Number", "Amended Seal No", "EIR #", "Issue Date", "In Date","Location - From", "Depo Loc","BE #", "BL #", "Line #","Trailer #","In Transport", "In Remarks"]
   import_ladenstock_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
   import_issuebalance = ["ID", "Container Number", "Size", "Type", "Height","Company", "Agent", "MLO", "Vessel", "Rotation #",  "Line #", "BE #", "BL #","Importer", "CNF", "EIR #","Location - From", "Depo Loc","Seal Number", "Amended Seal No", "Issue Date"]
   import_issuebalance_summary= ["Agent", "MLO", "Size-Type", "Sound", "Repaired", "Damage", "Wash", "Sweep", "Clean", "Total"]
   

    Axlsx::Package.new do |p|
      wb = p.workbook
         wb.styles do |s| 
             heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => false}
               date_format = s.add_style :format_code => 'YYYY-MM-DD'
  
        header = s.add_style :bg_color => "FFFFFF", :fg_color => "000000", :b => true, :sz => 10, :border => { :style => :thin, :color => "000000" }     
        wb.add_worksheet(:name => "In Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importInReport], import_in, header    
           end
         
         wb.add_worksheet(:name => "In Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importInReportSummary], import_in_summary, header, false
           end
          
           wb.add_worksheet(:name => "Unstuffing Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Total Import Container Unstuffing Report'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReport], import_unstuffing, header    
           end

           wb.add_worksheet(:name => "Unstuffing Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Total Import Container Unstuffing Summary'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReportSummary], import_unstuffing_summary, header, false 
           end
        
        wb.add_worksheet(:name => "FCL Out Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Total Import Container FCL Out Report'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReport], import_fclout, header  
           end
        
        wb.add_worksheet(:name => "FCL Out Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Total Import Container FCL Out Summary'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReportSummary], import_fclout_summary, header,false
           end

     

        wb.add_worksheet(:name => "Laden Stock Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Import Laden Container Stock Report'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReport], import_ladenstock, header  
             sheet.col_style 24, date_format, :row_offset => 1 
              sheet.col_style 25, date_format, :row_offset => 1 
           end

        wb.add_worksheet(:name => "Laden Stock Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Laden Stock Report Summary'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReportSummary], import_ladenstock_summary, header, false 
        end

        wb.add_worksheet(:name => "Issue Balance Report") do |sheet|
             add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Import Issue Balance Report'
             prepare_workbook sheet, options[:containerinfo][:issueBalanceReport], import_issuebalance, header      
           end

        wb.add_worksheet(:name => "Issue Balance Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name], sheet, heading, 'Import Issue Balance Report Summary' 
            prepare_workbook sheet, options[:containerinfo][:issueBalanceReportSummary], import_issuebalance_summary, header, false
           end
     
        end 
        p.serialize(options[:filename])

        Rails.logger.info '########  Storing mail info at db ######' 
        EmailService.create_email options
    end
    
  end 

    
    

end