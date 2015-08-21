class CardsController < ApplicationController
  before_action :find_card, only: [:show, :update, :edit]

  def index
    @cards = Card.all
  end

  def show
    @card.review_date = now_plus_days(3)
    @card.save
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(card_params)
    @card.review_date = now_plus_days(3)
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

  def now_plus_days(days)
    Time.new + days_in_sec(days)
  end

  def days_in_sec(days)
    days * 24 * 60 * 60
  end

  def find_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
end
