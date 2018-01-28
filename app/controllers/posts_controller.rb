class PostsController < ApplicationController
	before_action :authenticate_user!, except: [:index_published, :show, :new, :create, :upvote]
	load_and_authorize_resource
	
	def index
		if params[:tag]
			@posts = Post.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 5).order(created_at: :desc)
		else
			#paginates and orders by newest first
			@posts = Post.paginate(:page => params[:page], :per_page => 5).order(created_at: :desc)
		end
		@tags = ActsAsTaggableOn::Tag.most_used(6)

	end

	def index_published
		if params[:tag]
			@posts = Post.where(published: true).tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 5).order(created_at: :desc)
		elsif params[:search]
			@posts = Post.where(published: true).search(params[:search]).paginate(:page => params[:page], :per_page => 5).order(created_at: :desc)
		else
			@posts = Post.where(published: true).paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
		end
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


	# make the post public
	def publish
		@post = Post.find(params[:id])
		@post.published = true
		#@post.update(published: true)
		@post.save

		redirect_to posts_path
	end

	def unpublish
		@post = Post.find(params[:id])
		@post.published = false
		#@post.update(published: true)
		@post.save

		redirect_to posts_path
	end


	## TAGS
	def tag_cloud
	    @tags = Post.tag_counts_on(:tags)
	end

	def destroy_unused_tags
		@tags_to_delete = ActsAsTaggableOn::Tag.where('taggings_count' != 0)
		@tags_destroy_all
	end
	########

	## Vote system

	def upvote
		if !current_user.liked? @post
			@post.liked_by current_user
		elsif current_user.liked?@post
			@post.unliked_by current_user
		end
	end
	def downvote
		if !current_user.disliked? @post
			@post.disliked_by current_user
		elsif current_user.disliked?@post
			@post.undisliked_by current_user
		end
	end

	#dontvote later

	###########



private
	def post_params
		params.require(:post).permit(:body, :published, :tag_list)
	end
end
