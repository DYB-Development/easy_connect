EasyConnect::Engine.routes.draw do
  namespace :manage do
    resources :boards, only: :show
  end
end
