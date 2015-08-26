module ReviewsHelper
  def cards_to_review
    @to_remind = Rails.cache.fetch("cards_to_review").count
    # @to_remind = Card.reminder.count
  end
end
