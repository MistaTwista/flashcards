class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  after_create :add_current_deck

  belongs_to :current_deck, class_name: "Deck"
  has_many :decks
  has_many :authentications, dependent: :destroy
  has_many :cards, through: :decks

  with_options if: lambda { |obj| !obj.password.empty? } do |u|
    u.validates :password, length: { minimum: 3 }, on: [:create, :update]
    u.validates :password, confirmation: true, on: [:create, :update]
    u.validates :password_confirmation, presence: true, on: [:create, :update]
  end
  validates :email, uniqueness: true, presence: true, on: :create, email: true
  validates :email, email: true, on: :update

  def add_current_deck
    decks.create(name: "Default deck")
  end

  def all_or_current_deck_cards
    if !current_deck.nil?
      current_deck.cards
    else
      cards
    end
  end

  def for_review_counter
    all_or_current_deck_cards.for_review if !all_or_current_deck_cards.nil?
  end

  def for_review
    all_or_current_deck_cards.random if !all_or_current_deck_cards.nil?
  end

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end
end
