Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :pins, except: [:new, :edit], defaults: {format: :json}
    end
  end

  resources :pins
end
