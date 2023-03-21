Rails.application.routes.draw do
  resources :tasks, defaults: { format: :json }
end
