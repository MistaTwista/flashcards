namespace :mailer do
  desc "Searching for users with cards for review available and notifying them"
  task notify_users_with_reviews_available: :environment do
    Card.notify_users_with_reviews_available
  end
end
