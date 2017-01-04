Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  get 'charts/index'

  get  'children/clear_filter'
  get  'children/import'
  post 'children/import', to: 'children#do_import'
  resources :children

  get  'sign_ins/clear_filter'
  get  'sign_ins/import'
  post 'sign_ins/import', to: 'sign_ins#do_import'
  resources :sign_ins

  get 'json/children'

  scope '/api' do
    post '/auth_user', to: 'api#authenticate_user'
    scope '/v1' do
      scope '/children' do
        get '/', to: 'api#children'
      end
      scope '/sign_ins' do
        post '/create', to: 'api#create_sign_in'
      end
    end
  end

end
