
require 'axlsx'

class CreateImportContainerReportXls < CreateExcelTemplate
   
   def self.perform(options={}) 
    puts "Creating Import Container Movement Report"

    Axlsx::Package.new do |p|
      wb = p.workbook
      wb.styles.fonts.first.name = 'Calibri'
         wb.styles do |s| 
             heading = s.add_style :fg_color=> "004586", :b => true,  :bg_color => "FFFFFF", :sz => 12, 
                            :border => { :style => :thin, :color => "00" },
                            :alignment => { :horizontal => :center,  :vertical => :center , :wrap_text => false}
             date_format = s.add_style :format_code => 'YYYY-MM-DD'
  
        header = {:heading=>heading, :date_format=> date_format}  
        wb.add_worksheet(:name => "In Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importInReport], header   
           end  unless options[:containerinfo][:importInReport].blank?
         
         wb.add_worksheet(:name => "In Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Import Container In Report'
            prepare_workbook sheet, options[:containerinfo][:importInReportSummary], header, false
           end unless options[:containerinfo][:importInReport].blank?
         
          
           wb.add_worksheet(:name => "Unstuffing Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Total Import Container Unstuffing Report'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReport], header   
           end unless options[:containerinfo][:importUnstuffingReport].blank?
         

           wb.add_worksheet(:name => "Unstuffing Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Total Import Container Unstuffing Summary'
            prepare_workbook sheet, options[:containerinfo][:importUnstuffingReportSummary], header, false 
           end unless options[:containerinfo][:importUnstuffingReport].blank?
         
        
        wb.add_worksheet(:name => "FCL Out Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Total Import Container FCL Out Report'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReport], header  
           end unless options[:containerinfo][:importFclOutReport].blank?
         
         
        wb.add_worksheet(:name => "FCL Out Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Total Import Container FCL Out Summary'
            prepare_workbook sheet, options[:containerinfo][:importFclOutReportSummary], header,false
           end unless options[:containerinfo][:importFclOutReport].blank?
         

     

        wb.add_worksheet(:name => "Laden Stock Report") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Import Laden Container Stock Report'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReport], header 
          end unless options[:containerinfo][:importLadenStockReport].blank?
         

        wb.add_worksheet(:name => "Laden Stock Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Laden Stock Report Summary'
            prepare_workbook sheet, options[:containerinfo][:importLadenStockReportSummary], header, false 
         end unless options[:containerinfo][:importLadenStockReport].blank?
         

        wb.add_worksheet(:name => "Issue Balance Report") do |sheet|
             add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Import Issue Balance Report'
             prepare_workbook sheet, options[:containerinfo][:issueBalanceReport], header
           end unless options[:containerinfo][:issueBalanceReport].blank?
         

        wb.add_worksheet(:name => "Issue Balance Report Summary") do |sheet|
            add_header options[:permitted_depo_name], options[:client_name] + ' ( ' + options[:client_code] + ')', sheet, header, 'Import Issue Balance Report Summary' 
            prepare_workbook sheet, options[:containerinfo][:issueBalanceReportSummary], header, false
           end unless options[:containerinfo][:issueBalanceReport].blank?
         
        end 
        p.use_shared_strings = true
        p.serialize(options[:filename])
        Rails.logger.info '########  Storing mail info at db ######' 
        EmailService.create_email options
        true
    end
  end 
end