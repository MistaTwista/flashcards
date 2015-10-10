FactoryGirl.define do
  factory :deck, aliases: [:current_deck] do
    name "Default deck"
    user
  end
end
