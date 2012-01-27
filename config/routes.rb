SlotCarMadness::Application.routes.draw do

  root :to => 'track#index'

  resources :track, :only => [:index]

end
