# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, and :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :confirmable

  # Associations

  has_many :posts, foreign_key: 'author_id'

  validates :name, presence: true, length: { maximum: 50 }
end
