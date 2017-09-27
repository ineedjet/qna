Rails.application.routes.draw do
  devise_for :users

  concern :voted do
    member do
      post :vote_positive
      post :vote_negative
      post :vote_del
    end
  end

  resources :questions, concerns: [:voted], shallow: true do
    resources :answers, concerns: [:voted] do
      patch 'set_best', on: :member
    end
  end

  resources :attachments, only: :destroy

  root to: "questions#index"

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
