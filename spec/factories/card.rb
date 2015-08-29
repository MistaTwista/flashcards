FactoryGirl.define do

  factory :card do
    original_text "олень"
    translated_text "deer"
  end

  factory :card_without_translation, class: Card do
    original_text "олень"
  end

  factory :card_without_orig, class: Card do
    translated_text "deer"
  end

  factory :card_with_equals, class: Card do
    original_text " Deer"
    translated_text "    dEeR  "
  end

end
