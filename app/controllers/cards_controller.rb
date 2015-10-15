class CardsController < ApplicationController
  before_action :find_card, only: [:show, :update, :edit]
  before_action :set_user_decks, only: [:index, :update, :edit]

  def redirect_to_new_deck(message: "At lease one deck needed")
    redirect_to new_deck_path, flash: { info: message }
  end

  def index
    current_user.decks.empty? ? redirect_to_new_deck : @cards = current_user.current_deck_or_any.cards
  end

  def show
  end

  def new
    current_user.decks.empty? ? redirect_to_new_deck : @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    if @card.save
      redirect_to @card
    else
      render "new"
    end
  end

  def update
    if @card.update(card_params)
      redirect_to @card
    else
      render "edit"
    end
  end

  def edit
    # @new_deck = Deck.new
  end

  def destroy
    Card.delete(params[:id])
    redirect_to cards_path
  end

  private

  def set_user_decks
    @decks = current_user.decks
  end

  def find_card
    @card = Card.find(params[:id])
  end

  def deck_params
    params.require(:new_deck).permit(:name)
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :deck_id, :picture, :review_date)
  end
end
