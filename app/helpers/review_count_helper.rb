module ReviewCountHelper
  def number_of_cards_for_review(show_text: false, text: "Осталось вспомнить ")
    if current_user.decks.any?
      if show_text
        content_tag :p do
          concat(text)
          concat(content_tag(:span, current_user.for_review_counter.count, class: "badge"))
        end
      else
        content_tag :span, current_user.for_review_counter.count, class: "badge"
      end
    end
  end
  def current_deck_name
    current_user.current_deck_or_any.name if current_user.decks.any?
  end
end
