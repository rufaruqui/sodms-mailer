class CreateExcelTemplate
    def self.add_header(depo_name, client_name, sheet, style_info, report_name)
      sheet.add_row [depo_name],   style: style_info[:heading], height: 20 
      sheet.add_row [client_name], style: style_info[:heading], height: 16
      sheet.add_row [report_name], style: style_info[:heading], height: 14 
     
    end
   
    def self.prepare_workbook(sheet, data, style_info, hidden=true) 
             keys = data.first.keys.select{|k| k.to_s.match(/id|Id|currentDepotUnit/)}
             h = data.first.keys - keys
           # h = data.first.delete_if { |key, value| !key.to_s.match(/Id/) }
           damage_details = [:damageAreaName, :damagePartName, :damageDescription, :damageComponent, :damageType, :repairType]
           if data.blank? or !data.first.include?:containerNumber or data.first[:id] == 0
             sheet.add_row [""], style: style_info[:heading], height: 16   
           else
              sheet.add_row ["Total number of containers : #{data.pluck(:containerNumber).uniq.count}"], style: style_info[:heading], height: 16   
           end
          
           sheet.add_row ["SL #"].push(h.map(&:to_s).map(&:titleize)).flatten, style: style_info[:heading]  
          if data.first[:id] != 0
            sl = 1
            data.each_with_index do |info, index|
               a = h #info.keys 
              if index > 0 and info.include?:containerNumber and data[index][:containerNumber] == data[index-1][:containerNumber]
                 sheet.add_row  [" "].push(a.map{|item| (damage_details.include? item ) ? info[item] : nil}).flatten
              else
                sheet.add_row    [sl].push(a.map{|item| info[item]}).flatten
               sl +=1
              end

            end    
          else
             sheet.add_row [""], style: style_info[:heading], height: 16   
          end
           format_workbook sheet, data.first.keys, style_info
         #  sheet.column_info.second.hidden = hidden 
    end

    def self.format_workbook(sheet, data, style_info) 
      keys = data.select{|k| k.to_s.match(/id|Id|currentDepotUnit/)}
      h = data - keys    
      h.each_with_index do |item, index|  
        sheet.col_style index+1, style_info[:date_format], :row_offset => 5 if item.to_s.downcase.include?  "date" 
      end

      sheet.merge_cells("A1:AG1")
      sheet.merge_cells("A2:AG2")
      sheet.merge_cells("A3:AG3")
      sheet.merge_cells("A4:AG4")
      sheet.column_info.first.width = 5
    end
end