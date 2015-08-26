module ReviewsHelper
  def cards_to_review
    @to_remind = Card.reminder_count
  end
end
