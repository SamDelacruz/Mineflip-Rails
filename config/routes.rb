Rails.application.routes.draw do
  get 'tiles/update'
  resources :games, only: [:show, :create] do
    put 'tiles/:tile_x/:tile_y', to: 'tiles#update'
  end
end
