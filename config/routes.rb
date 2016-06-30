Spree::Core::Engine.routes.draw do
 resources :registries
  resources :registryed_products, only: [:create, :update, :destroy]
  get '/registry' => 'registries#default', as: 'default_registry'
end
