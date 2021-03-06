class LikesController < ApplicationController
  include ApplicationHelper
  
  def create
    type = type_subject?(params)[0]
    @subject = type_subject?(params)[1]
    # notice_type = "like-#{type}"
    return unless @subject
    if already_liked?(@subject, type)
      dislike(type)
    else
      @like = @subject.likes.build(user_id: current_user.id)
      if @like.save
        flash[:notice] = "#{type} liked!"
      else
        flash[:alert] = "#{type} like failed!"
      end
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def type_subject?(params)
    type = 'post' if params.key?('post_id')
    type = 'comment' if params.key?('comment_id')
    subject = Post.find(params[:post_id]) if type == 'post'
    subject = Comment.find(params[:comment_id]) if type == 'comment'
    [type, subject]
  end

  def dislike(type)
    @like = Like.find_by(post_id: params[:post_id]) if type == 'post'
    @like = Like.find_by(comment_id: params[:comment_id]) if type == 'comment'
    return unless @like
    @like.destroy
    redirect_back(fallback_location: root_path)
  end
end
