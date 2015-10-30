class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :user
  accepts_nested_attributes_for :deck

  before_create :set_defaults

  ERRORS_TO_DECREASE = 3
  LEVENSHTEIN_DISTANCE_MAXIMUM = 2
  SECONDS_TO_ANSWER = {
    fast: 8,
    slow: 15,
  }.freeze

  has_attached_file :picture, styles: { medium: "360x360>", thumb: "50x50>" }, default_url: "/images/placeholder.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :original_text, :translated_text, presence: true
  validates :deck_id, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Time.now) }

  def check_translation(translation, time)
    l_distance = Text::Levenshtein.distance(translated_text, clear(translation))
    if l_distance < LEVENSHTEIN_DISTANCE_MAXIMUM
      correct = true
      get_next_interval(correct, time)
    else
      correct = false
      get_next_interval(correct, time)
    end
    { correct: correct, levenshtein_distance: l_distance }
  end

  def get_next_interval(correct, time)
    sm = SuperMemoService.new
    if correct
      q = quality_from_timer(time)
    else
      q = 0
    end
    next_step = sm.next_step(q, memo_ef, memo_interval)
    self.memo_ef = next_step[:new_ef]
    self.memo_interval = next_step[:new_i]
    self.review_date = Time.now + memo_interval.seconds
    save
  end

  def quality_from_timer(time)
    if time.to_i > SECONDS_TO_ANSWER[:slow]
      3
    elsif time.to_i > SECONDS_TO_ANSWER[:fast]
      4
    else
      5
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
      errors.add(:translated_text, I18n.t("cards.cant_be_equal"))
    end
  end

  def clear(field)
    field.squish.mb_chars.downcase.to_s unless field.nil?
  end

  def set_defaults
    self.review_date = Time.now
  end
end
