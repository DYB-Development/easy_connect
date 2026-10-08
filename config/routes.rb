EasyConnect::Engine.routes.draw do
  namespace :manage do
    resources :boards, only: :show do
      resource :lines, only: [ :create, :destroy ]
    end
  end
end
