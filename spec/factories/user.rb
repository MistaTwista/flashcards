FactoryGirl.define do
  factory :user do
    email "example@example.com"
    password "123123"
    password_confirmation "123123"
    association :current_deck, factory: :deck
  end

end
