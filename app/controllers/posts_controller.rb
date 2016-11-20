class PostsController < ApplicationController
	before_action :authenticate_admin!, except: [:index_published, :show, :new, :create]

	def index
		if params[:tag]
			@posts = Post.tagged_with(params[:tag])
		else
			@posts = Post.all
		end
	end

	def index_published
		@posts = Post.all
	end

	def new
		@post = Post.new
	end

	def show
		@post = Post.find(params[:id])
	end

	def edit
		@post = Post.find(params[:id])
	end

	def create
		@post = Post.new(post_params)
		#@post = Post.new(post_params)
 
		if @post.save
		   redirect_to published_posts_path
		else
		   render 'new'
		end
	end

	def update
		@post = Post.find(params[:id])

		if @post.update(post_params)
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy

		redirect_to posts_path
	end

	#custom method
	def publish
		@post = Post.find(params[:id])
		@post.published = true
		#@post.update(published: true)
		@post.save

		redirect_to posts_path
	end

	

private
	def post_params
		params.require(:post).permit(:body, :published, :tag_list)
	end
end
