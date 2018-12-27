class EmailService
    def self.create_email(options)
     Email.create(:recipients=>options[:recipents], 
                     :subject=>options[:subject], 
                     :attachment=>options[:filename], 
                     :body=>options[:body], 
                     :attachment_name=>options[:attachment_name], 
                     :mail_type=>options[:mail_type], 
                     :state=>0, 
                     :clientid=>options[:clientid], 
                     :permitteddepoid=>options[:permitteddepoid],
                     :client_name=>options[:client_name],
                     :permitted_depo_name=>options[:permitted_depo_name],
                     :mail_delivery_setting_id=>options[:mail_delivery_setting_id],
                     :cc=>options[:cc]
                     )
    end

    def self.import_container_report_email_body (info)
          <<-EOF 
             Dear #{info[:clientName]},
                
                Kindly see the attached Import Container Combining Report for the Date #{Time.now.strftime("%d/%m/%Y")}.
                
                Client Name: #{info[:clientName]}  Client Code: #{info[:clientName]}
                Depot      :  #{info[:permittedDepotName]}
                
                Container Combining Report Includes:
                  1. In Report
                  2. In Summary
                  3. Unstuffing Report
                  4. Unstuffing Summary
                  5. FCL Out Report
                  6. FCL Out Summary
                  7. Laden Stock Report
                  8. Laden Stock Summary
              
                NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person.

              Best Regards
              Customer Service Department
              #{info[:permittedDepotName]}
         EOF

        end
    def self.container_report_email_body (info)
          <<-EOF 
             Dear #{info[:clientName]},
                
                Kindly see the attached Container Combining Report for the Date #{Time.now.strftime("%d/%m/%Y")}.
                
                Client Name: #{info[:clientName]}  Client Code: #{info[:clientName]}
                Depot      :  #{info[:permittedDepotName]}
                
                Container Combining Report Includes:
                  1. In Report
                  2. In Summary
                  3. Out Empty Report
                  4. Out Empty Summary
                  5. Out Laden Report
                  6. Out Laden Summary
                  7. Stock Report
                  8. Stock Summary
              
                NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person.

              Best Regards
              Customer Service Department
              #{info[:permittedDepotName]}
         EOF

        end
end