namespace :mailer do
  desc "Searching for users with cards for review available and notifying them"
  task notify_users_with_reviews_available: :environment do
    User.get_review_counters.each do |user|
      cards_for_review = user.for_review
      if cards_for_review > 1
        notify_about_cards_for_review(user)
      end
    end
  end

  def notify_about_cards_for_review(user)
    NotificationMailer.cards_for_review_available(user).deliver_now
  end
end
