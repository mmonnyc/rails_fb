class PostsController < ApplicationController
  def index
    @feed_posts = current_user.my_feed_posts
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(posts_params)
    if @post.save
      flash[:notice] = 'Posted!'
      redirect_to @post
    else
      render 'new'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    return unless current_user.id == @post.user_id
    @post.destroy
    flash[:notice] = 'Post deleted'
    redirect_to root_path
  end

  private

  def posts_params
    params.require(:post).permit(:context)
  end
end
