class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards

  validates :name, :user, presence: true

  # before_save :set_deck_to_current_user

  # def set_deck_to_current_user
  #   user = current_user
  # end
end
