class User < ActiveRecord::Base
  include ActiveModel::Validations
  before_save :email_downcase
  validates :email, :password, presence: true
  validates :email, uniqueness: true, on: :create
  validates :email, email: true
  has_many :cards

  def self.email_list
    email_list = {}
    User.all.each do |u|
      # email_list << { u.email => u.id }
      email_list[u.email] = u.id
    end
    email_list
  end

  private

  def email_downcase
    self.email = email.downcase
  end
end
