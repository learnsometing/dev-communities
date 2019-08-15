# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[github]

  # Associations
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :sent_friend_requests, class_name: 'FriendRequest',
                                  foreign_key: 'requestor_id',
                                  dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest',
                                      foreign_key: 'friend_id',
                                      dependent: :destroy
  has_many :notification_changes, foreign_key: 'actor_id',
                                  dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notification_objects, through: :notifications
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, source: :friend
  has_one :user_location, dependent: :destroy
  has_one :location, through: :user_location
  acts_as_taggable
  acts_as_taggable_on :skills
  acts_as_messageable
  mount_uploader :profile_picture, ProfilePictureUploader
  # Validations

  validates :name, presence: true, length: { maximum: 50 }
  validate :picture_size

  # CarrierWave for Image Upload
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name

      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.github_data'] && session['devise.github_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.search(term)
    # Search users by their name, location and skills
    results = []
    where('name ILIKE ?', "%#{term}%").each { |user| results << user} # Good
    UserLocation.search_by_loc_title(term).each { |ul| results << ul.user }
    User.tagged_with(term, any: true).each { |user| results << user }
    results.uniq
  end

  def feed
    Post.where(author_id: id).or(Post.where(author_id: friend_ids))
  end

  def authored_posts
    # Return the posts that belong to this user. Used in the users#show action
    # to avoid a template error pertaining to the new post that is built and sent
    # to the view. Since a newly built post does not have a created_at timestamp
    # stftime will be undefined since created_at is nil.
    Post.where(author_id: id)
  end

  private

  def picture_size
    msg = 'should be less than 5MB'
    errors.add(:profile_picture, msg) if profile_picture.size > 5.megabytes
  end
end
