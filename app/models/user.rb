class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

	# validates :name, :surname, presence: true
	has_many :images, as: :imageable
	accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['url'].blank?}

  def jwt_payload
    super
  end

end
