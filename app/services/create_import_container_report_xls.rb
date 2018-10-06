
require 'axlsx'

class CreateImportContainerReportXls
   def self.perform(options={}) 
      Axlsx::Package.new do |p|

        wb = p.workbook
         wb.styles do |s| 
           heading = s.add_style alignment: {horizontal: :center}, b: true, sz: 18, bg_color: "0066CC", fg_color: "FF"


       #   head = s.add_style :bg_color => "00", :fg_color => "FF"

        # defaults =  { :style => :thick, :color => "000000" }
        # borders = Hash.new do |hash, key|
        #   hash[key] = wb.styles.add_style :border => defaults.merge( { :edges => key.to_s.split('_').map(&:to_sym) } )
        # end
        # top_row =  [0, borders[:top_left], borders[:top], borders[:top], borders[:top_right]]
        # middle_row = [0, borders[:left], nil, nil, borders[:right]]
        # bottom_row = [0, borders[:bottom_left], borders[:bottom], borders[:bottom], borders[:bottom_right]]

         

        p.workbook.add_worksheet(:name => "In Report") do |sheet|
            add_header sheet, heading, 'Import Container In Report'
            sheet.add_row ["SL #", "Container #", "Size", "Type", "Current Depo" "Permitted Depo", "Agent", "MLO", "F. Loc", "Imp. Vessel", "Imp. Rotation", "Cond", "DI Agent", "DI Mlo", "DI Date" "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importInReport].each do |info|  
               sheet.add_row    info.values
              end
           end

         p.workbook.add_worksheet(:name => "In Report Summary") do |sheet|
            add_header sheet, heading, 'Import Container In Report'
            sheet.add_row ["SL #", "Container #", "Size", "Type", "Current Depo" "Permitted Depo", "Agent", "MLO", "F. Loc", "Imp. Vessel", "Imp. Rotation", "Cond", "DI Agent", "DI Mlo", "DI Date" "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importInReportSummary].each do |info|  
               sheet.add_row    info.values
              end
           end
          
           p.workbook.add_worksheet(:name => "Unstuffing Report") do |sheet|
            add_header sheet, heading, 'Total Import Container Unstuffing Report'
            sheet.add_row ["SL #", "Container #", "Size", "Type", "Current Depo" "Permitted Depo", "Agent", "MLO", "F. Loc", "Imp. Vessel", "Imp. Rotation", "Cond", "DI Agent", "DI Mlo", "DI Date" "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importUnstuffingReport].each do |info|  
               sheet.add_row    info.values
              end
           end

           p.workbook.add_worksheet(:name => "Unstuffing Report Summary") do |sheet|
            add_header sheet, heading, 'Total Import Container Unstuffing Summary'
            sheet.add_row ["SL #", "Container #", "Size", "Type", "Current Depo" "Permitted Depo", "Agent", "MLO", "F. Loc", "Imp. Vessel", "Imp. Rotation", "Cond", "DI Agent", "DI Mlo", "DI Date" "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importUnstuffingReportSummary].each do |info|  
               sheet.add_row    info.values
              end
           end
        
        p.workbook.add_worksheet(:name => "FCL Out Report") do |sheet|
            add_header sheet, heading, 'Total Import Container FCL Out Report'
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importFclOutReport].each do |info|  
               sheet.add_row    info.values
              end
           end
        
        p.workbook.add_worksheet(:name => "FCL Out Report Summary") do |sheet|
            add_header sheet, heading, 'Total Import Container FCL Out Summary'
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importFclOutReportSummary].each do |info|  
               sheet.add_row    info.values
              end
           end

     

        p.workbook.add_worksheet(:name => "Laden Stock Report") do |sheet|
            add_header sheet, heading, 'Import Laden Container Stock Report'
            sheet.add_row ["ID #", "Container #", "Size", "Type", "Agent", "MLO", "Current Depo", "Permitted Depo", "Imp. Vessel", "Imp. Rotation", "F. Loc", "In Date", "Condition", "Storage Day", "Status", "Status Name", "DI Agent", "DI Mlo", "DI Date", "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importLadenStockReport].each do |info|  
               sheet.add_row    info.values
              end             
           end

        p.workbook.add_worksheet(:name => "Laden Stock Report Summary") do |sheet|
            add_header sheet, heading, 'Laden Stock Report Summary'
            sheet.add_row ["ID #", "Container #", "Size", "Type", "Agent", "MLO", "Current Depo", "Permitted Depo", "Imp. Vessel", "Imp. Rotation", "F. Loc", "In Date", "Condition", "Storage Day", "Status", "Status Name", "DI Agent", "DI Mlo", "DI Date", "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:importLadenStockReportSummary].each do |info|  
               sheet.add_row    info.values
            end 
        end

        p.workbook.add_worksheet(:name => "Issue Balance Report") do |sheet|
            add_header sheet, heading, 'Import Issue Balance Report'
            sheet.add_row ["ID #", "Container #", "Size", "Type", "Agent", "MLO", "Current Depo", "Permitted Depo", "Imp. Vessel", "Imp. Rotation", "F. Loc", "In Date", "Condition", "Storage Day", "Status", "Status Name", "DI Agent", "DI Mlo", "DI Date", "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:issueBalanceReport].each do |info|  
               sheet.add_row    info.values
              end             
           end

        p.workbook.add_worksheet(:name => "Issue Balance Report Summary") do |sheet|
            add_header sheet, heading, 'Import Issue Balance Report Summary'
            sheet.add_row ["ID #", "Container #", "Size", "Type", "Agent", "MLO", "Current Depo", "Permitted Depo", "Imp. Vessel", "Imp. Rotation", "F. Loc", "In Date", "Condition", "Storage Day", "Status", "Status Name", "DI Agent", "DI Mlo", "DI Date", "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:issueBalanceReportSummary].each do |info|  
               sheet.add_row    info.values
              end             
           end
        end 
        p.serialize(options[:filename])

        Rails.logger.info '########  Storing mail info at db ######' 
        Email.create(:recipients=>options[:recipents], :subject=>options[:subject], :attachment=>options[:filename], :body=>options[:body], :attachment_name=>options[:attachment_name], :mail_type=>options[:mail_type])
        #ReportMailer.daily_email_update(options).deliver_at(Time.now)
    end
    
  end 

    def self.add_header(sheet, heading, report_name)
      sheet.merge_cells("A1:M1");
      sheet.merge_cells("A2:M2");
      sheet.merge_cells("A3:M3");
      sheet.merge_cells("A4:M4");
      sheet.add_row [" SUMMIT ALLIANCE PORT LIMITED (OCL) "], style: heading, height: 20
      sheet.add_row [" KATGHAR, NORTH PATENGA, CHITTAGONG-4204. "] , style: heading, height: 18
      sheet.add_row [" MAERSK LINE  / MAERSK LINE(MAERSK BANGLADESH LTD.)"] , style: heading, height: 16
      sheet.add_row [report_name], style: heading, height: 14 
    end

end