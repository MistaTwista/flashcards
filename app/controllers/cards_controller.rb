class CardsController < ApplicationController
  before_action :find_card, only: [:show, :update, :edit]
  before_action :set_user_decks, only: [:index, :update, :edit]

  def redirect_to_new_deck(message: "At lease one deck needed")
    redirect_to new_deck_path, flash: { info: message }
  end

  def index
    if current_user.decks.empty?
      redirect_to_new_deck
    else
      @cards = current_user.all_or_current_deck_cards
    end
  end

  def show
  end

  def new
    if current_user.decks.empty?
      redirect_to_new_deck
    else
      @card = Card.new
    end
  end

  def create
    @card = new_card
    if @card.save!
      redirect_to @card
    else
      render "new"
    end
  end

  def new_card
    if params[:new_deck_name].present?
      Card.new_with_new_deck(card_params, deck_params, current_user)
    else
      Card.new(card_params)
    end
  end

  def update
    if update_card
      redirect_to @card
    else
      render "edit"
    end
  end

  def update_card
    if params[:new_deck_name].present?
      Card.update_with_new_deck(@card, card_params, deck_params, current_user)
    else
      @card.update(card_params)
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

  def deck_params
    params.permit(:new_deck_name)
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :deck_id, :picture, :review_date)
  end
end
