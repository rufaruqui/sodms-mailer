require 'axlsx'

class GenStockReportXls
   def self.perform(options={})
      Axlsx::Package.new do |p|

        wb = p.workbook
       #  wb.styles do |s| 
       #   head = s.add_style :bg_color => "00", :fg_color => "FF"

        # defaults =  { :style => :thick, :color => "000000" }
        # borders = Hash.new do |hash, key|
        #   hash[key] = wb.styles.add_style :border => defaults.merge( { :edges => key.to_s.split('_').map(&:to_sym) } )
        # end
        # top_row =  [0, borders[:top_left], borders[:top], borders[:top], borders[:top_right]]
        # middle_row = [0, borders[:left], nil, nil, borders[:right]]
        # bottom_row = [0, borders[:bottom_left], borders[:bottom], borders[:bottom], borders[:bottom_right]]

         

        p.workbook.add_worksheet(:name => "In Report") do |sheet|
            add_header sheet
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:stockinfo].each do |info|  
               sheet.add_row    info.values
              end
           end

        
        p.workbook.add_worksheet(:name => "Out Empty Report") do |sheet|
            add_header sheet
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:stockinfo].each do |info|  
               sheet.add_row    info.values
              end
           end


        p.workbook.add_worksheet(:name => "Out Laden Report") do |sheet|
            add_header sheet
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:stockinfo].each do |info|  
               sheet.add_row    info.values
              end
           end


        p.workbook.add_worksheet(:name => "Stock Report") do |sheet|
            add_header sheet
            sheet.add_row ["Container #", "Size", "Type", "Permitted Depo", "Gate In Depo", "Agent", "MLO Clinet", "Condition", "Vessel", "Gate In Date", "Rotation #", "Prime Mover #", "Storage Days"] 
            #sheet.add_row options[:stockinfo][0].keys unless options[:stockinfo].blank?
            options[:stockinfo].each do |info|  
               sheet.add_row    info.values
              end
           end
        
      p.serialize(options[:filename])
     end
    end

    def self.add_header(sheet)
          sheet.add_row ["																						SUMMIT ALLIANCE PORT LIMITED (OCL)																						"]
          sheet.add_row ["																						KATGHAR, NORTH PATENGA, CHITTAGONG-4204.																						"] 
          sheet.add_row ["																						MAERSK LINE  / MAERSK LINE(MAERSK BANGLADESH LTD.)																						"] 
          sheet.add_row ['																						Total Container Stock Report																						'] 
    end

end