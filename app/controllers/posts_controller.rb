class PostsController < ApplicationController
  def index
    @feed_posts = current_user.my_feed_posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(posts_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Your post was successfully created' }
      else
        render 'new'
      end
    end
  end

  def destroy; end

  private

  def posts_params
    params.require(:post).permit(:context)
  end
end
