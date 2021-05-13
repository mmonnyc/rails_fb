class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]
  validates :first_name, length: { in: 3..15 }, presence: true
  validates :last_name, length: { in: 3..15 }, presence: true
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

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name # assuming the user model has a first name
      user.last_name = auth.info.last_name # assuming the user model has a last name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if (data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info'])
        user.email = data['email'] if user.email.blank?
      end
    end
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
    friendships.map{ |f| f.sent_to if !f.status}.compact
  end
  # Friend requests for the user 
  def friend_requests
    inverse_friendships.map{ |f| f.sent_by if !f.status}.compact
  end

  private 

  def picture_size
    errors.add(:image, 'should be less than 1MB') if image.size > 1.megabytes
  end
end
