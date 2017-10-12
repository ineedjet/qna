 Rails.application.routes.draw do
  use_doorkeeper
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

  namespace 'api' do
    namespace 'v1' do
      resources :profiles  do
        get 'me', on: :collection
      end
    end
  end


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
