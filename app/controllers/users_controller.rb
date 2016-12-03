class UsersController < ApplicationController
	before_filter :authenticate_user!


	def index
		@users = User.paginate(:page => params[:page], :per_page => 5)
	end

	def show
	    @user = User.find(params[:id])
	    unless current_user.admin?
	      unless @user == current_user
	        redirect_to :back, :alert => "Access denied."
	      end
	    end
	 end

	def edit_role
		@user = User.find(params[:id])
	end

	
	def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(secure_params)
	      redirect_to users_path, :notice => "User updated."
	    else
	      redirect_to users_path, :alert => "Unable to update user."
	    end
	end

	def destroy
	    user = User.find(params[:id])
	    user.destroy
	    redirect_to users_path, :notice => "User deleted."
	end


	private
	
	def secure_params
	   params.require(:user).permit(:role)
	end


	def admin_only
		unless current_user.role == "admin"
			redirect_to :back, :alert => "Access Denied"
		end
	end
end
