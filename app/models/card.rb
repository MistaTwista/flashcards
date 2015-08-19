class Card < ActiveRecord::Base
  validates :original_text, :translated_text, :review_date, presence: true
end
