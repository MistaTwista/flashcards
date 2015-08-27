module ReviewCountHelper
  def number_of_cards_for_review(show_text: false, text: "Осталось вспомнить ")
    if show_text
      content_tag :p do
        concat(text)
        concat(content_tag(:span, Card.for_review.count, class: "badge"))
      end
    else
      content_tag :span, Card.for_review.count, class: "badge"
    end
  end
end
