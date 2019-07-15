# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[github]

  # Associations

  has_many :posts, foreign_key: 'author_id'

  # Validations

  validates :name, presence: true, length: { maximum: 50 }
  validate :picture_size

  # CarrierWave for Image Upload

  mount_uploader :profile_picture, ProfilePictureUploader

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image

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

  private

  def user_params
    params.require(:user).permit(:profile_picture)
  end

  def picture_size
    msg = 'should be less than 5MB'
    errors.add(:profile_picture, msg) if profile_picture.size > 5.megabytes
  end
end
