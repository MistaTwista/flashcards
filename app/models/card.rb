class Card < ActiveRecord::Base
  before_validation :normalize_fields, :set_default_review_date
  validates :original_text, :translated_text, :review_date, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Time.now).order("RANDOM()") }

  def move_review_date
    self.review_date = Time.now + 3.days
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

  protected

  def not_equal_fields
    if clear(original_text) == clear(translated_text)
      errors.add(:translated_text, "can't be the same as Original text")
    end
  end

  def clear(field)
    field.squish.mb_chars.downcase.to_s
  end

  def set_default_review_date
    self.review_date = Time.now + 3.days
  end

  def normalize_fields
    self.original_text = self.original_text.squish()
    self.translated_text = self.translated_text.squish()
  end
end
