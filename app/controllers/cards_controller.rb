class CardsController < ApplicationController
  before_action :find_card, only: [:show, :update, :edit]
  before_action :set_user_decks, only: [:index, :update, :edit]

  def redirect_to_new_deck(message: "At lease one deck needed")
    redirect_to(new_deck_path, flash: { info: message })
  end

  def index
    if current_user.decks.any?
      @cards = current_user.current_deck_or_any.cards
    else
      redirect_to_new_deck
    end
  end

  def show
  end

  def new
    if current_user.decks.any?
      @card = Card.new
    else
      redirect_to_new_deck
    end
  end

  def create
    @card = current_user.current_deck_or_any.cards.new(card_params)
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

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :deck_id, :picture, :review_date)
  end
end
