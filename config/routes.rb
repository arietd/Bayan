Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :posts do
  	collection do
    	get "index_published" # generate  get "/products/most_popular"
    	put "publish/:id" , to: 'posts#publish', as: 'publish'
  	end
  end

   root 'posts#index'
end
