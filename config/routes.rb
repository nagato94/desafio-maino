# config/routes.rb
Rails.application.routes.draw do
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

  # Redireciona qualquer rota com locale não capturado para a raiz
end
