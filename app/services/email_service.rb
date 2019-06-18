class EmailService
    def self.create_email(options)
        options[:attachment_name] = options[:attachment_name].present? ? options[:attachment_name] : nil; 
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
                
             Kindly see the attached Import Container Movement Report for the Date #{(Time.now-1.day).strftime("%d/%m/%Y")}.
                
             Client Name: #{info[:clientName] if info[:clientName]}  
             Client Code: #{info[:clientCode] if info[:clientCode]} 
                
             Import Container Movement Report Includes:

                  1. In Report  #{ '[' + info[:summary][:importInReport].to_s + ' of container(s) ]' if info[:summary][:importInReport] > 0 }
                  2. In Summary
                  3. Unstuffing Report #{ '[' + info[:summary][:importUnstuffingReport].to_s + ' of container(s) ]' if info[:summary][:importUnstuffingReport] > 0 }
                  4. Unstuffing Summary
                  5. FCL Out Report #{ '[' + info[:summary][:importFclOutReport].to_s + ' of container(s) ]' if info[:summary][:importFclOutReport] > 0 }
                  6. FCL Out Summary
                  7. Laden Stock Report #{ '[' + info[:summary][:importLadenStockReport].to_s + ' of container(s) ]' if info[:summary][:importLadenStockReport] > 0 }
                  8. Laden Stock Summary
                  9. Issue Balance Report   #{ '[' + info[:summary][:issueBalanceReport].to_s + ' of container(s) ]' if info[:summary][:issueBalanceReport] > 0 }
                  10. Issue Balance Report Summary
             
                System will not include excel attachment if there are no container to show. 

                NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person.

             Best Regards
             Customer Service Department
             #{info[:permittedDepotName]}
         EOF

        end
    def self.container_report_email_body (info)
          <<-EOF 
             Dear #{info[:clientName]},
                
             Kindly see the attached Container Movement Report for the Date #{(Time.now-1.day).strftime("%d/%m/%Y")}.
                
             Client Name: #{info[:clientName] if info[:clientName]}  
             Client Code: #{info[:clientCode] if info[:clientCode]} 
                
             Container Movement Report Includes:
             
                   1. In Report          #{ '[' + info[:summary][:inReport].to_s + ' of container(s) ]' if info[:summary][:inReport] > 0 }
                   2. In Summary
                   3. Out Empty Report   #{ '[' + info[:summary][:outEmptyReport].to_s + ' of container(s) ]' if info[:summary][:inReport] > 0 }
                   4. Out Empty Summary
                   5. Out Laden Report   #{ '[' + info[:summary][:outLadenReport].to_s + ' of container(s) ]' if info[:summary][:inReport] > 0 }
                   6. Out Laden Summary
                   7. Empty Stock Report       #{ '[' + info[:summary][:stockReport].to_s + ' of container(s) )' if info[:summary][:inReport] > 0 }
                   8. Empty Stock Summary 
                   9. Laden Stock Report       #{ '[' + info[:summary][:ladenStockReport].to_s + ' of container(s) )' if info[:summary][:inReport] > 0 }
                  10. Laden Stock Summary 
              

             System will not include excel attachment if there are no container to show. 

             NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person. Reports with 0 container are not generated.

             Best Regards
             Customer Service Department
             #{info[:permittedDepotName]}
         EOF

        end

    def self.cargo_report_email_body (info)
          <<-EOF 
            Dear #{info[:clientName]},
                
            Kindly see the attached Cargo Report for the Date #{(Time.now-1.day).strftime("%d/%m/%Y")}.
                
            Client Name: #{info[:clientName]}  Client Code: #{info[:clientName]}
            Depot      :  #{info[:permittedDepotName]}
                
                 
              
            NB: This is a system generated mail sent automatically. So if you found any problem in the report, please contact with our respective person.

            Best Regards
            Customer Service Department
            #{info[:permittedDepotName]}
         EOF

        end

end