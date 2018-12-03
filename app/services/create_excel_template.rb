class CreateExcelTemplate
    def self.add_header(depo_name, client_name, sheet, style_info, report_name)
      sheet.add_row [depo_name], style: style_info[:heading], height: 20
    #  sheet.add_row [" KATGHAR, NORTH PATENGA, CHITTAGONG-4204. "] , style: heading, height: 18
      sheet.add_row [client_name] , style:  style_info[:heading], height: 16
      sheet.add_row [report_name], style:  style_info[:heading], height: 14 
     
    end
   
    def self.prepare_workbook(sheet, data, style_info, hidden=true) 

           if data.blank? or !data.first.include?:containerNumber or data.first[:id] == 0
             sheet.add_row [""], style: style_info[:heading], height: 16   
           else
              sheet.add_row ["Total number of conatiners:#{data.pluck(:containerNumber).uniq.count}"], style: style_info[:heading], height: 16   
           end
          
           sheet.add_row ["SL #"].push(data.first.keys.map(&:to_s).map(&:titleize)).flatten, style: style_info[:heading]  
          if data.first[:id] != 0
            sl = 1
             data.each do |info|
               sheet.add_row    [sl].push(info.values).flatten
               sl +=1
            end    
          else
             sheet.add_row [""], style: style_info[:heading], height: 16   
          end
           format_workbook sheet, data.first.keys, style_info
            sheet.column_info.second.hidden = hidden 
    end

    def self.format_workbook(sheet, data, style_info) 
      data.each_with_index do |item, index|  
        sheet.col_style index+1, style_info[:date_format], :row_offset => 6 if item.to_s.downcase.include?  "date" 
      end
        sheet.column_info.first.width = 5
        
          sheet.merge_cells("A1:AG1")
          sheet.merge_cells("A2:AG2")
          sheet.merge_cells("A3:AG3")
          sheet.merge_cells("A4:AG4")
    end
end