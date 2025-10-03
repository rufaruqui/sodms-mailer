Rails.application.routes.draw do
  resources :mail_types

  # Explicit email routes (resources :emails should generate these, but adding explicitly)
  get    'emails'          => 'emails#index',   as: 'emails'
  post   'emails'          => 'emails#create'
  get    'emails/new'      => 'emails#new',     as: 'new_email'
  get    'emails/:id'      => 'emails#show',    as: 'email'
  get    'emails/:id/edit' => 'emails#edit',    as: 'edit_email'
  patch  'emails/:id'      => 'emails#update'
  put    'emails/:id'      => 'emails#update'
  delete 'emails/:id'      => 'emails#destroy'

  get 'resend_email'                        => 'emails#resend_email'
  post 'resend_emails'                       => 'emails#resend_emails'
   
      
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ResqueWeb::Engine => "/resque_web"
end
