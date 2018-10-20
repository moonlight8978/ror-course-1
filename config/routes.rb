Rails.application.routes.draw do
  root to: 'test#index'

  get 'test', to: 'test#index'
end
