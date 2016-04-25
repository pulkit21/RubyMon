class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable
          # :confirmable
  include DeviseTokenAuth::Concerns::User

  has_many :teams, dependent: :destroy
  has_many :monsters, dependent: :destroy
end
