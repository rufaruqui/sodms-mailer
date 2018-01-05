Mail.defaults do
      delivery_method :smtp,  address: "smtp.gmail.com", 
      port: 587, 
      user_name: "sapl.mailer@gmail.com",
      password: "saplsapl@ict",
      authentication: "plain",
      enable_starttls_auto: true
end
