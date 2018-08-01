Rails.application.routes.draw do
  resources :mail_types
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ResqueWeb::Engine => "/resque_web"
end
