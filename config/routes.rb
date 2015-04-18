Rails.application.routes.draw do
  resources :emergencies, except: [:new, :edit]
  resources :responders, except: [:new, :edit]
end
