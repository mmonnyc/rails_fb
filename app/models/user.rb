class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validate :picture_size
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many :friendships, class_name: 'Friendship',
                          foreign_key: 'sent_by_id',
                          # inverse_of: 'sent_to',
                          dependent: :destroy
  has_many :inverse_friendships, class_name: 'Friendship',
                          foreign_key: 'sent_to_id',
                          # inverse_of: 'sent_by',
                          dependent: :destroy
  
  def my_feed_posts
    my_friends = self.friends
    my_feed_posts = []
    my_friends.each do |f|
      f.posts.each do |p|
        my_feed_posts << p
      end
    end
    posts.each do |p|
      my_feed_posts << p
    end
    my_feed_posts
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def friends
    friends_array = friendships.map{ |f| f.sent_to if f.status } + inverse_friendships.map{ |f| f.sent_by if f.status }
    friends_array.compact
  end

  # Users sent requests to other friends
  def pending_requests
    friendships.map{ |f| f.sent_by if !f.status}.compact
  end
  # Friend requests for the user 
  def friend_requests
    inverse_friendships.map{ |f| f.sent_to if !f.status}.compact
  end

  private 

  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
