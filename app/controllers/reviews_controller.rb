class ReviewsController < ApplicationController
  before_action :find_card, only: [:trainer]

  def new
    @card = Card.reviews.first
  end

  def trainer
    if right_translation?
      flash[:success] = t("messages.home.success")
      redirect_to reviews_path
    else
      flash[:danger] = t("messages.home.failure")
      redirect_to reviews_path
    end
  end

  def right_translation?
    if @card.right_translation?(review_params[:translated_text])
      @card.move_review
      return true
    else
      return false
    end
  end

  private

  def find_card
    @card = Card.find(review_params[:id])
  end

  def review_params
    params.require(:card).permit(:translated_text, :id)
  end
end
