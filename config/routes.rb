Rails.application.routes.draw do
  namespace :api do
    resources :movies do
      collection do
        match 'upload', to: 'movies#upload', via: [:put]
        get 'video_url/:key', to: 'movies#get_video_url'
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
