Rails.application.routes.draw do
  resources :mail_types
  resources :emails
  get 'resend_email'                        => 'emails#resend_email'
  post 'resend_emails'                       => 'emails#resend_emails'
   
      
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ResqueWeb::Engine => "/resque_web"
end
