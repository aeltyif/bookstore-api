Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :publishing_houses
  resources :authors do
    collection do
      post :issue_to_author
    end
  end
  resources :books
end
