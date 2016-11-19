Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :posts do
  	collection do
    	get "index_published", to: 'posts#index_published', as: 'published'
    	put "publish/:id" , to: 'posts#publish', as: 'publish'
  	end
  end

   root 'posts#index_published'
end
