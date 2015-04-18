Rails.application.routes.draw do
  resources :emergencies, defaults: { format: :json }, except: [:new, :edit]
  resources :responders, defaults: { format: :json }, except: [:new, :edit]

  # Custom not found
  match '*path', to: 'application#not_found', via: :all
end
