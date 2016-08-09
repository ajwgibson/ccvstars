Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  get 'charts/index'
  
  resources :children

  get 'registrations/index'

end
