class DecksController < ApplicationController
  before_action :find_deck, only: [:show, :update, :edit]

  def index
    @decks = current_user.decks
  end

  def show
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = current_user.decks.new(deck_params)
    if @deck.save
      redirect_to @deck
    else
      render "new"
    end
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck
    else
      render "edit"
    end
  end

  def edit
  end

  def destroy
    Deck.delete(params[:id])
    redirect_to decks_path
  end

  private

  def find_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
