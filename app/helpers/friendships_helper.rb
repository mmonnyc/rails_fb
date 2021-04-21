module FriendshipsHelper
  include ApplicationHelper

  def create
    @user = User.find(params[:user_id])

    return if current_user.id == params[:user_id]
    return if friend_request_received?(@user)
    return if friend_request_sent?(@user)

    if @friendship.save
      flash[:success] = "Friend request successfully sent!"
      @notification = new_notification(@user, @current_user.id, 'friendRequest')
      @notification.save
    else
      flash[:danger] = "Friend request failed!"
    end
    redirect_back(fallback_location: root_path)
  end

  def accept_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship

    @friendship.status = true
    if @friendship.save
      flash[:success] = "You have a new friend!"
    else
      flash[:danger] = "Friend request could not be accepted"
    end
    redirect_back(fallback_location: root_path)
  end

  def decline_friend
    @friendship = Friendship.find_by(sent_by_id: params[:user_id], sent_to_id: current_user.id, status: false)
    return unless @friendship

    @friendship.destroy
    flash[:success] = "Friend request declined"
    redirect_back(fallback_location: root_path)
  end
end
