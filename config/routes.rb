Hybrasyl::Application.routes.draw do

  root :to => 'ealagad#index'
  match '/contact' => 'ealagad#contact'
  match '/launcher' => 'ealagad#launcher'
  match '/about' => 'ealagad#about'
  match '/about/credits' => 'ealagad#credits'
  match '/releases' => 'ealagad#releases'
  match '/account/manager' => 'account#manager'
  match '/account/link' => 'account#link'
  match '/account/character/:id/reset' => 'account#reset'

  devise_for :accounts
  devise_for :accounts, :path => 'admin', :path_names => { :sign_in => 'sign_in' }

  ActiveAdmin.routes(self)

  namespace :admin do
    match '/worldmaps/:id/pointeditor' => 'worldmaps#pointeditor'
  end

  namespace :api do
    namespace :v1 do
      post 'login/player', :to => "api#player_login"
      post 'login/account', :to => "api#account_login"
      get 'status', :to => "api#status"
    end
  end


end
