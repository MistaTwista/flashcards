class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  after_create :add_current_deck

  belongs_to :current_deck, class_name: "Deck"
  has_many :decks
  has_many :authentications, dependent: :destroy
  has_many :cards, through: :decks

  with_options on: [:create, :update], if: lambda { |obj| obj.password.nil? } do |u|
    u.validates :password, length: { minimum: 3 }
    u.validates :password, confirmation: true
    u.validates :password_confirmation, presence: true
  end
  validates :email, uniqueness: true, presence: true, on: :create, email: true
  validates :email, email: true, on: :update

  scope :for_review_counters_at, lambda { |time|
    joins(:cards).
      select("id", "email", "count(cards.id) as for_review").
      where("review_date < ?", time).
      group("id")
  }

  CARDS_LIMIT_BEFORE_NOTIFY = 0

  def add_current_deck
    decks.create(name: I18n.t("decks.default"))
  end

  def all_or_current_deck_cards
    if !current_deck.nil?
      current_deck.cards
    else
      cards
    end
  end

  def cards_for_review
    all_or_current_deck_cards.for_review unless all_or_current_deck_cards.nil?
  end

  def card_for_review
    all_or_current_deck_cards.random unless all_or_current_deck_cards.nil?
  end

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end

  def self.notify_users_with_reviews_available
    for_review_counters_at(Time.now).each do |user|
      cards_for_review = user.for_review
      if cards_for_review > CARDS_LIMIT_BEFORE_NOTIFY
        NotificationMailer.cards_for_review_available(user).deliver_now
      end
    end
  end
end
