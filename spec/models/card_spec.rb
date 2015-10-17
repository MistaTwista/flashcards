require 'rails_helper'

describe Card do
  let!(:card) { create(:card) }

  it "false with original == translation" do
    user = build(:user, email: "deer@deer.ru")
    deck = build(:deck, user: user)
    card = build(:card, original_text: " оСень  ", translated_text: "     ОсЕНЬ ", deck: deck)
    expect(card).to be_invalid
  end

  it "#check_translation" do
    expect(card.check_translation("ifdnq02")).to be false
  end

  it "#review_date" do
    expect(card.review_date).to eq(Date.today + 3.days)
  end

  it "#review_date after translation check" do
    card.check_translation("face")
    expect(card.review_date).to eq(Date.today + 3.days)
  end
end
