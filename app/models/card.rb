class Card < ActiveRecord::Base
  before_validation :normalize_fields
  after_validation :console_message, on: :create
  validates :original_text, :translated_text, :review_date, presence: true
  validate :not_equal_fields

  protected

  def not_equal_fields
    if clean(original_text) == clean(translated_text)
      errors.add(:translated_text, "can't be the same as Original text")
    end
  end

  def clean(field)
    field.delete(" ").mb_chars.downcase.to_s
  end

  def console_message
    puts "Creating new card "+self.original_text+"\/"+self.translated_text
  end

  def normalize_fields
    self.original_text = self.original_text.squish()
    self.translated_text = self.translated_text.squish()
  end
end
