Rails.application.routes.draw do

  devise_for :users

  root "home#index"

  get "coach/dashboard",
      to: "coach_dashboard#show",
      as: :coach_dashboard

  resources :coach_profiles do
    resources :reviews,
              only: [:create, :destroy]
  end

  resources :student_profiles,
            only: [:show, :edit, :update]

  resources :categories,
            only: [:index, :show]

  resources :services

  resources :bookings do
    member do
      patch :confirm
      patch :cancel
      patch :complete
    end
  end

  resources :comments,
            only: [:create, :update, :destroy]

  resources :community_groups

  resources :group_memberships,
            only: [:create, :destroy]

  resources :membership_plans,
            only: [:index, :show]

  get "up" => "rails/health#show",
      as: :rails_health_check
end
