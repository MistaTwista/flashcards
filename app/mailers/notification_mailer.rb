class NotificationMailer < ApplicationMailer
  def cards_for_review_available(user)
    @user = user
    mail to: @user.email, subject: t('notify.cards.available')
  end
end
