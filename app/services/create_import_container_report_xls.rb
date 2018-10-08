
require 'axlsx'

class CreateImportContainerReportXls
   
   def self.perform(options={}) 

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
             heading = s.add_style :fg_color=> "004586",
                            :b => true,
                            :bg_color => "FFFFFF",#"004586",
                            :sz => 12,
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,
                                            :vertical => :center ,
                                            :wrap_text => false}

          header = s.add_style :bg_color => "FFFFFF", :fg_color => "000000", :b => true, :sz => 10, :border => { :style => :thin, :color => "000000" }

       
        wb.add_worksheet(:name => "In Report") do |sheet|
            add_header sheet, heading, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReportSummary], import_in, header    
           end
         
         wb.add_worksheet(:name => "In Report Summary") do |sheet|
            add_header sheet, heading, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importInReportSummary], import_in_summary, header, false
           end
          
           wb.add_worksheet(:name => "Unstuffing Report") do |sheet|
            add_header sheet, heading, 'Total Import Container Unstuffing Report'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReport], import_unstuffing, header    
           end

           wb.add_worksheet(:name => "Unstuffing Report Summary") do |sheet|
            add_header sheet, heading, 'Total Import Container Unstuffing Summary'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReportSummary], import_unstuffing_summary, header, false 
           end
        
        wb.add_worksheet(:name => "FCL Out Report") do |sheet|
            add_header sheet, heading, 'Total Import Container FCL Out Report'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReport], import_fclout, header  
           end
        
        wb.add_worksheet(:name => "FCL Out Report Summary") do |sheet|
            add_header sheet, heading, 'Total Import Container FCL Out Summary'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReportSummary], import_fclout_summary, header,false
           end

     

        wb.add_worksheet(:name => "Laden Stock Report") do |sheet|
            add_header sheet, heading, 'Import Laden Container Stock Report'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReport], import_ladenstock, header  
           end

        wb.add_worksheet(:name => "Laden Stock Report Summary") do |sheet|
            add_header sheet, heading, 'Laden Stock Report Summary'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReportSummary], import_ladenstock_summary, header, false 
        end

        wb.add_worksheet(:name => "Issue Balance Report") do |sheet|
             add_header sheet, heading, 'Import Issue Balance Report'
             prepare_workbook sheet, options[:containerinfo][:issueBalanceReport], import_issuebalance, header      
           end

        wb.add_worksheet(:name => "Issue Balance Report Summary") do |sheet|
            add_header sheet, heading, 'Import Issue Balance Report Summary' 
            prepare_workbook sheet, options[:containerinfo][:issueBalanceReportSummary], import_issuebalance_summary, header, false
           end
     
        end 
        p.serialize(options[:filename])

        Rails.logger.info '########  Storing mail info at db ######' 
        Email.create(:recipients=>options[:recipents], :subject=>options[:subject], :attachment=>options[:filename], :body=>options[:body], :attachment_name=>options[:attachment_name], :mail_type=>options[:mail_type], :state=>0, :clientid=>options[:clientid], :permitteddepoid=>options[:permitteddepoid])
    end
    
  end 

    def self.add_header(sheet, heading, report_name)
      sheet.add_row [" SUMMIT ALLIANCE PORT LIMITED (OCL) "], style: heading, height: 20
      sheet.add_row [" KATGHAR, NORTH PATENGA, CHITTAGONG-4204. "] , style: heading, height: 18
      sheet.add_row [" MAERSK LINE  / MAERSK LINE(MAERSK BANGLADESH LTD.)"] , style: heading, height: 16
      sheet.add_row [report_name], style: heading, height: 14 
       
      sheet.merge_cells("A1:AD1");
      sheet.merge_cells("A2:AD2");
      sheet.merge_cells("A3:AD3");
      sheet.merge_cells("A4:AD4");
      sheet.merge_cells("A5:AD5");
       
      
    end
   
    def self.prepare_workbook(sheet, data, header_info, style_info, hidden=true) 
            sheet.add_row ["Total number of conatiners:#{data.length}"], style: style_info, height: 16 unless data.blank? or !data[0].include?:containerNumber
            sheet.add_row
            sheet.merge_cells("A6:AD6");
            
            sheet.add_row header_info, style: style_info   
            data.each do |info|
               sheet.add_row    info.values
            end    
            sheet.column_info[0].hidden = hidden
    end

end