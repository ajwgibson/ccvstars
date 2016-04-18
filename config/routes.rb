Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  get 'charts/index'
  get 'children/index'
  get 'registrations/index'

end
