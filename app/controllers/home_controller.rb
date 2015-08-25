class HomeController < ApplicationController
  def index
    @card = Card.reminder
    # shame
    @to_remind = Card.where("review_date < ?", Time.now+1.day).count
    # /shame
  end

  def trainer
    # не понятно как избавиться от ['card'],
    # вроде через params.permit, но не получилось
    @card = Card.find(params['card'][:id])
    if @card.translated_text == params['card'][:translated_text]
      @card.move_review
      flash[:success] = t('messages.home.success')
      redirect_to root_path
    else
      flash[:danger] = t('messages.home.failure')
      redirect_to root_path
    end
  end
end
