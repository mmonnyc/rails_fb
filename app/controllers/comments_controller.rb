class CommentsController < ApplicationController
  include ApplicationHelper
  
  def index
    @comments = Comments.all
  end

  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    respond_to do |format|
      if @comment.save
        #@notification = new_notification(@post.user, @post.id, 'comment')
        #@notification.save
        format.html { redirect_to @post, notice: 'Comment was successfully created' }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user.id == @comment.user_id
    @comment.destroy
    flash[:success] = 'Comment deleted'
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
