class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  belongs_to :deck
  has_many :decks
  has_many :authentications, dependent: :destroy
  has_many :cards

  accepts_nested_attributes_for :authentications

  validates :password, length: { minimum: 3 }, on: [:create, :update], if: :password_present?
  validates :password, confirmation: true, on: [:create, :update], if: :password_present?
  validates :password_confirmation, presence: true, on: [:create, :update], if: :password_present?
  validates :email, uniqueness: true, presence: true, on: :create, email: true
  validates :email, email: true, on: :update

  def current_deck
    if self.decks.any?
      nil
    end
    if self.deck == nil
      if self.decks.one?
        self.decks.first
      else
        offset = rand(self.decks.count)
        self.decks.offset(offset).first
      end
    else
      self.deck
    end
  end

  def password_present?
    !password.empty?
  end

  def for_review_counter
    current_deck.for_review_counter
  end

  def for_review
    current_deck.for_review
  end

  def has_linked_github?
    authentications.where(provider: 'github').present?
  end
end
