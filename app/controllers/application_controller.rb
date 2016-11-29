class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def after_sign_in_path_for(resource)
  	if resource.role == "admin"
  		posts_path
  	else
  		published_posts_path	
  	end
  end
  
end
