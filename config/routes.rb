Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users do
    collection do
      get "edit_role/:id", to: "users#edit_role", as: "edit_role"
    end
  end
  resources :posts do
  	collection do
    	get "index_published", to: 'posts#index_published', as: 'published'
    	put "publish/:id" , to: 'posts#publish', as: 'publish'
  	end
  end

  get 'tags/:tag', to: 'posts#index', as: 'tag'

  root 'posts#index_published'
end
