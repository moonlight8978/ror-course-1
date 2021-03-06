Rails.application.routes.draw do
  root to: 'categories#index'

  get 'test', to: 'test#index'

  scope module: :sessions do
    get 'sign_in', action: :new
    post 'sign_in', action: :create
    get 'sign_out', action: :destroy
  end

  scope module: :registrations do
    get 'sign_up', action: :new
    post 'sign_up', action: :create
  end

  resources :users, only: :show
  resource :me, only: :show

  resources :categories, shallow: true, only: %i[index show] do
    resources :topics, except: :index do
      resources :posts, except: :index
    end
  end

  namespace :admin do
    root to: 'dashboards#index'

    resources :dashboards, only: :index
  end

  resources :languages, only: :index
end
