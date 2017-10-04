 Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  concern :voted do
    member do
      post :vote_positive
      post :vote_negative
      post :vote_del
    end
  end

  resources :questions, concerns: [:voted,], shallow: true do
    resources :comments, only: [:create]
    resources :answers, concerns: [:voted] do
      resources :comments, only: [:create]
      patch 'set_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :comments, only: [:update, :destroy]

  root to: "questions#index"

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
