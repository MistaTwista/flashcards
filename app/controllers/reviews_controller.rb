class ReviewsController < ApplicationController
  before_action :find_card, only: [:create]

  def new
    @card = current_user.card_for_review
  end

  def create
    result = @card.check_translation(review_params[:translated_text])
    l_dist = result[:levenshtein_distance]
    words = t("messages.review.words",
              in_card_word: @card.translated_text,
              entered_word: review_params[:translated_text])
    message = ""
    if result[:correct]
      message = t("messages.review.levenshtein", count: l_dist)
      flash[:success] = t("messages.review.success") + message + words
    else
      flash[:danger] = t("messages.review.failure") + message
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
