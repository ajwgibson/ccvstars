Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  get 'charts/index'
  
  get 'children/clear_filter'
  resources :children

  get 'registrations/index'

  resources :child_uploads

end
