Hybrasyl::Application.routes.draw do

  root :to => 'ealagad#index'
  get '/contact' => 'ealagad#contact'
  get '/launcher' => 'ealagad#launcher'
  get '/about' => 'ealagad#about'
  get '/about/credits' => 'ealagad#credits'
  get '/releases' => 'ealagad#releases'
  get '/account/manager' => 'account#manager'
  get '/account/link' => 'account#link'
  get '/account/character/:id/reset' => 'account#reset'

  devise_for :accounts, ActiveAdmin::Devise.config.merge(path_names: { :sign_in => 'sign_in' })

  ActiveAdmin.routes(self)

  namespace :admin do
    get '/worldmaps/:id/pointeditor' => 'worldmaps#pointeditor'
  end

  namespace :api do
    namespace :v1 do
      post 'login/player', :to => "api#player_login"
      post 'login/account', :to => "api#account_login"
      get 'status', :to => "api#status"
    end
  end
end
