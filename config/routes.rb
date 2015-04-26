Rails.application.routes.draw do
  resources :emergencies, param: :code, defaults: { format: :json }, except: [:new, :edit]
  resources :responders, param: :name, defaults: { format: :json }, except: [:new, :edit]

  # Custom not found
  match '*path', to: 'application#not_found', via: :all
end
