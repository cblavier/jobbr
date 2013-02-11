Rails.application.routes.draw do

  resource :home

  root to: 'home#index'

  mount Jobbr::Engine => "/jobbr"

end
