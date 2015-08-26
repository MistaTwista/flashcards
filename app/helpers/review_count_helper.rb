module ReviewCountHelper
  def cards_to_review(show_text: false, text: "Осталось вспомнить ")
    to_remind = Rails.cache.fetch("cards_to_review")
    if show_text
      content_tag :p do
        concat(text)
        concat(content_tag(:span, to_remind, class: 'badge'))
      end
    else
      content_tag :span, to_remind, class: 'badge'
    end
  end
end
