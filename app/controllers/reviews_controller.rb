class ReviewsController < ApplicationController
  before_action :find_card, only: [:create]

  def new
    @card = Card.random_card(@current_user)
    if @card == nil
      render 'no_reviews_left'
    end
  end

  def create
    if @card.check_translation(review_params[:translated_text])
      flash[:success] = t("messages.home.success")
    else
      flash[:danger] = t("messages.home.failure")
    end
    redirect_to new_review_path
  end

  private

  def find_card
    @card = Card.find(review_params[:card_id])
  end

  def review_params
    params.require(:review).permit(:translated_text, :card_id)
  end
end
