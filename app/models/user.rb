class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  after_create :add_current_deck

  belongs_to :current_deck, class_name: "Deck"
  has_many :decks
  has_many :authentications, dependent: :destroy
  has_many :cards

  with_options if: :password_present? do |u|
    u.validates :password, length: { minimum: 3 }, on: [:create, :update]
    u.validates :password, confirmation: true, on: [:create, :update]
    u.validates :password_confirmation, presence: true, on: [:create, :update]
  end
  validates :email, uniqueness: true, presence: true, on: :create, email: true
  validates :email, email: true, on: :update

  def add_current_deck
    decks.create(name: "Default deck")
  end

  def current_deck_or_any
    if not decks.any?
      nil
    end
    if current_deck == nil
      select_any_deck
    else
      current_deck
    end
  end

  def select_any_deck
    if decks.one?
      current_deck = decks.first
    else
      offset = rand(decks.count)
      current_deck = decks.offset(offset).first
    end
  end

  def password_present?
    :password.empty?
  end

  def for_review_counter
    current_deck_or_any.cards.for_review if not current_deck_or_any.nil?
  end

  def for_review
    current_deck_or_any.cards.random if not current_deck_or_any.nil?
  end

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end
end
