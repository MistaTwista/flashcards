class Card < ActiveRecord::Base
  belongs_to :user
  before_validation :set_default_review_date
  validates :original_text, :translated_text, :review_date, :user_id, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Date.today) }
  scope :current_user, -> (user) { where("user_id = ?", user) }

  def move_review_date
    self.review_date = Date.today + 3.days
    save
  end

  def check_translation(translation)
    if translated_text == clear(translation)
      move_review_date
      return true
    else
      return false
    end
  end

  def self.for_user(user)
    for_review.current_user(user)
  end

  def self.random_card(user)
    offset = rand(for_review.current_user(user).count)
    for_review.current_user(user).offset(offset).first
  end

  protected

  def not_equal_fields
    if clear(original_text) == clear(translated_text)
      errors.add(:translated_text, "can't be the same as Original text")
    end
  end

  def clear(field)
    field.squish.mb_chars.downcase.to_s unless field.nil?
  end

  def set_default_review_date
    self.review_date = Date.today + 3.days
  end
end
