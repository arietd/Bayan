class PostsController < ApplicationController
	#before_action :authenticate_admin!, except: [:index_published, :show, :new, :create]
	before_filter :deny_to_visitors, except: [:index_published, :show, :new, :create]


	def index
		if params[:tag]
			@posts = Post.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 5)
		else
			@posts = Post.paginate(:page => params[:page], :per_page => 5)
		end
		@tags = ActsAsTaggableOn::Tag.most_used(5)

	end

	def index_published
		@posts = Post.where(published: true).paginate(:page => params[:page], :per_page => 10)

		@tags = ActsAsTaggableOn::Tag.most_used(5)
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

	def tag_cloud
	    @tags = Post.tag_counts_on(:tags)
	end

	def destroy_unused_tags
		@tags_to_delete = ActsAsTaggableOn::Tag.where('taggings_count' != 0)
		@tags_destroy_all
	end
	

private
	def post_params
		params.require(:post).permit(:body, :published, :tag_list)
	end

	def deny_to_visitors
	  redirect_to root_path unless user_signed_in? or admin_signed_in?
	end
end
