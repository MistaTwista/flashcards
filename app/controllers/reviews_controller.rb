class ReviewsController < ApplicationController
  before_action :find_card, only: [:create]

  def new
    @card = Card.reviews.first
  end

  def create
    check_translation
    redirect_to new_review_path
  end

  def check_translation
    if @card.right_translation?(review_params[:translated_text])
      @card.move_review
      flash[:success] = t("messages.home.success")
    else
      flash[:danger] = t("messages.home.failure")
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
