EasyConnect::Engine.routes.draw do
  namespace :manage do
    resources :boards, only: :show do
      resource :lines, only: [ :create, :destroy ]
      resource :save, only: :create
      resources :items, only: :update, id: /[^\/]+/
    end
  end
end
