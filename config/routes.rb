Rails.application.routes.draw do
  root to: 'test#index'

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
end
