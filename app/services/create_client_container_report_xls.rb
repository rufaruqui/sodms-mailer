
require 'axlsx'

class CreateClientContainerReportXls
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

         

        # p.workbook.add_worksheet(:name => "In Report") do |sheet|
        #     add_header sheet, heading
        #     sheet.add_row ["SL #", "Container #", "Size", "Type", "Current Depo" "Permitted Depo", "Agent", "MLO", "F. Loc", "Imp. Vessel", "Imp. Rotation", "Cond", "DI Agent", "DI Mlo", "DI Date" "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
        #     #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
        #     options[:containerinfo][:containerInReport].each do |info|  
        #        sheet.add_row    info.values
        #       end
        #    end

        
        # p.workbook.add_worksheet(:name => "Out Empty Report") do |sheet|
        #     add_header sheet, heading
        #     sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
        #     #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
        #     options[:stockinfo].each do |info|  
        #        sheet.add_row    info.values
        #       end
        #    end


        # p.workbook.add_worksheet(:name => "Out Laden Report") do |sheet|
        #     add_header sheet, heading
        #     sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
        #     #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
        #     options[:stockinfo].each do |info|  
        #        sheet.add_row    info.values
        #       end
        #    end


        p.workbook.add_worksheet(:name => "Stock Report") do |sheet|
            add_header sheet, heading
            sheet.add_row ["ID #", "Container #", "Size", "Type", "Agent", "MLO", "Current Depo", "Permitted Depo", "Imp. Vessel", "Imp. Rotation", "F. Loc", "In Date", "Condition", "Storage Day", "Status", "Status Name", "DI Agent", "DI Mlo", "DI Date", "Remarks", "Damage Area", "Damage Part", "Damage Description"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:containerinfo][:containerStockReport].each do |info|  
               sheet.add_row    info.values
              end 
             
           end
        
      p.serialize(options[:filename])
     end
    end
  end 

    def self.add_header(sheet, heading)
      sheet.add_row [" SUMMIT ALLIANCE PORT LIMITED (OCL) "], style: heading, height: 30
      sheet.add_row [" KATGHAR, NORTH PATENGA, CHITTAGONG-4204. "] , style: heading, height: 28
      sheet.add_row [" MAERSK LINE  / MAERSK LINE(MAERSK BANGLADESH LTD.)"] , style: heading, height: 28
      sheet.add_row ['Total Container Stock Report ']
      sheet.merge_cells("A1:M1");
      sheet.merge_cells("A2:M2");
      sheet.merge_cells("A3:M3");
      sheet.merge_cells("A4:M4"); 
    end

end