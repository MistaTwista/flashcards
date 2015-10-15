class Card < ActiveRecord::Base
  belongs_to :deck
  belongs_to :user
  accepts_nested_attributes_for :deck

  before_validation :set_default_review_date
  before_save :check_new_deck

  has_attached_file :picture, styles: { medium: "360x360>", thumb: "50x50>" }, default_url: "/images/placeholder.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :original_text, :translated_text, :review_date, presence: true
  validates :deck_id, presence: true
  validate :not_equal_fields
  scope :for_review, -> { where("review_date < ?", Date.today) }

  def check_new_deck
    # puts new_deck.name
    # if not new_deck.name.blank?
    #   @deck = Deck.new(name: params[:new_deck_name], user: current_user)
    #   @deck.save
    #   params[:deck_id] = @deck.id
    #   puts params[:deck_id]
    # end
  end

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

  def self.update_with_new_deck(card, card_params, deck_params, user)
    new_deck = Deck.create(name: deck_params[:name], user: user)
    card_params[:deck_id] = new_deck.id
    current_card = Card.find(card)
    current_card.update(card_params)
  end

  def self.new_with_new_deck(card_params, deck_params, user)
    new_deck = Deck.create(name: deck_params[:name], user: user)
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

  def set_default_review_date
    self.review_date = Date.today + 3.days
  end
end
