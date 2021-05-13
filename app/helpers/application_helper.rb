module ApplicationHelper
  def already_liked?(subject, type)
    result = false
    if type == 'post'
      result = Like.where(user_id: current_user.id, post_id: subject.id).exists?
    end
    if type == 'comment'
      result = Like.where(user_id: current_user.id, comment_id: subject.id).exists?
    end
    result
  end

  def friend_request_sent?(user)
    current_user.friendships.exists?(sent_to_id: user.id, status: false)
  end

  def friend_request_received?(user)
    current_user.inverse_friendships.exists?(sent_by_id: user.id, status: false)
  end
  
  def potential_friends?(user)
    return true if friend_request_sent?(user)
    return true if friend_request_received?(user)
    return true if current_user.friendships.exists?(sent_to_id: user.id, status: true)
    return true if current_user.inverse_friendships.exists?(sent_by_id: user.id, status: true)
    return false
  end
end
