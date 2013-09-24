Jobbr::Engine.routes.draw do

  root to: 'jobs#index'

  resources :jobs do
    resources :runs
  end

  resources :delayed_jobs

end
