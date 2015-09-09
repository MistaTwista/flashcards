class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true

  validates :email, uniqueness: true, presence: true, on: :create, email: true
  validates :email, email: true, on: :update
  has_many :cards

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end
end
