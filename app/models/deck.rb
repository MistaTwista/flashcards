class Deck < ActiveRecord::Base
  belongs_to :user
  has_many :cards

  def for_review
    self.cards.random
  end

  def for_review_counter
    self.cards.for_review
  end
end
