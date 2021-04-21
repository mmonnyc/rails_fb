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
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def destroy; end

  private

  def posts_params
    params.require(:post).permit(:content, :imageURL)
  end
end
