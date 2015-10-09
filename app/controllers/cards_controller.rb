class CardsController < ApplicationController
  before_action :find_card, only: [:show, :update, :edit]
  before_action :user_decks, only: [:index, :update, :edit]

  def index
    @cards = current_user.deck.cards
  end

  def show
  end

  def new
    @card = Card.new
  end

  def create
    @card = current_user.deck.cards.new(card_params)
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

  def user_decks
    @decks = current_user.decks
  end

  def find_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :deck_id, :picture, :review_date)
  end
end
