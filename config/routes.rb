Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  get 'charts/index'
  
  get  'children/clear_filter'
  get  'children/import'
  post 'children/import', to: 'children#do_import'
  resources :children

  get  'sign_ins/index'
  get  'sign_ins/clear_filter'
  get  'sign_ins/import'
  post 'sign_ins/import', to: 'sign_ins#do_import'

end
