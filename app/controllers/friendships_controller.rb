class FriendshipsController < ApplicationController
  include ApplicationHelper

  def create
    @user = User.find(params[:user_id])
    
    return if current_user.id == params[:user_id]
    return if friend_request_received?(@user)
    return if friend_request_sent?(@user)

    @friendship = current_user.friendships.build(sent_to_id: params[:user_id])
    if @friendship.save
      flash[:notice] = 'Friend Request Sent!'
    else
      flash[:alert] = 'Friend Request Failed!'
    end
    redirect_to users_path
  end

  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship

    @friendship.status = true
    if @friendship.save
      flash[:notice] = "You have a new friend!"
    else
      flash[:alert] = "Friend request could not be accepted"
    end
    redirect_to users_path
  end

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship

    @friendship.destroy
    flash[:notice] = "Friend request declined"
    redirect_to users_path
  end
end
