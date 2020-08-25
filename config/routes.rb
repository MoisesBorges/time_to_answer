Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index' #Dashboard
    resources :admins   #Administrators
    resources :subjects #Assuntos
    resources :questions #Questões
  end

  devise_for :users
  devise_for :admins
  get 'welcome/index'

  get 'inicio', to: 'site/welcome#index'

  root to:'site/welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
