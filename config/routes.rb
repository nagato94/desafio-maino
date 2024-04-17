# config/routes.rb
require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    # Suas rotas vão aqui
    devise_for :users
    root to: 'posts#index'
    get '/index', to: 'posts#index'
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
    resources :users, only: [:edit, :update]
  end
  resources :posts do
    member do
      get 'download'
    end
  end

  # Redireciona qualquer rota com locale não capturado para a raiz
end
