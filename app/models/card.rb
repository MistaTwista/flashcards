class Card < ActiveRecord::Base
  before_validation :normalize_fields, :date_review
  validates :original_text, :translated_text, :review_date, presence: true
  validate :not_equal_fields

  protected

  def not_equal_fields
    if clean(original_text) == clean(translated_text)
      errors.add(:translated_text, "can't be the same as Original text")
    end
  end

  def clean(field)
    field.squish.mb_chars.downcase.to_s
  end

  def date_review
    self.review_date = Time.now + 3.days
  end

  def normalize_fields
    self.original_text = self.original_text.squish()
    self.translated_text = self.translated_text.squish()
  end
end
