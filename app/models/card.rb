class Card < ActiveRecord::Base
  belongs_to :user
  before_validation :set_default_review_date
  has_attached_file :picture, styles: { medium: "360x360>", thumb: "50x50>" }, default_url: "/images/placeholder.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :original_text, :translated_text, :review_date, :user_id, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Date.today) }

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

  def self.random
    offset = rand(for_review.count)
    for_review.offset(offset).first
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
