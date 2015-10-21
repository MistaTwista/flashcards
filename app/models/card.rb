class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :user
  accepts_nested_attributes_for :deck

  before_create :set_defaults

  LEITNER_TIME = [
    0,
    12.hours,
    3.days,
    1.week,
    2.weeks,
    1.month
  ]

  MEMORY_LEVELS = LEITNER_TIME.length-1
  ERRORS_TO_DECREASE = 3


  has_attached_file :picture, styles: { medium: "360x360>", thumb: "50x50>" }, default_url: "/images/placeholder.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :original_text, :translated_text, presence: true
  validates :deck_id, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Time.now) }

  def check_translation(translation)
    if translated_text == clear(translation)
      increase_review_level
      return true
    else
      decrease_review_level
      return false
    end
  end

  def increase_review_level
    self.error_counter = 0
    if review_level < MEMORY_LEVELS
      self.review_level += 1
      new_date = Time.now + LEITNER_TIME[review_level]
      self.review_date = new_date
    end
    save
  end

  def decrease_review_level
    if review_level > 0
      if error_counter == ERRORS_TO_DECREASE
        self.review_level -= 1
        self.error_counter = 0
        save
      else
        self.error_counter += 1
        save
      end
    end
  end

  def self.leitner_step(review_step)
    today = Time.now
    case review_step
    when 1
      today + 12.hours
    when 2
      today + 3.days
    when 3
      today + 1.week
    when 4
      today + 2.weeks
    when 5
      today + 1.month
    else
      today
    end
  end

  def self.random
    offset = rand(for_review.count)
    for_review.offset(offset).first
  end

  def self.update_with_new_deck(card, card_params, deck_params, user)
    new_deck = Deck.create(name: deck_params[:new_deck_name], user: user)
    card_params[:deck_id] = new_deck.id
    card.update(card_params)
  end

  def self.new_with_new_deck(card_params, deck_params, user)
    new_deck = Deck.create(name: deck_params[:new_deck_name], user: user)
    card_params[:deck_id] = new_deck.id
    Card.new(card_params)
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

  def set_defaults
    self.review_date = Time.now
    self.review_level = 0
    self.error_counter = 0
  end
end
