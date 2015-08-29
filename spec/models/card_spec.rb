require 'rails_helper'

describe Card do
  it "card with original = translation" do
    card = build(:card, original_text: " оЛень  ", translated_text: "     ОлЕНЬ ")
    expect(card).to be_invalid
  end

  let!(:card) { create(:card) }

  it "#check_translation" do
    expect(card.check_translation("ifdnq02")).to be false
  end

  it "#review_date" do
    expect(card.review_date == Date.today + 3.days).to be true
  end

  it "#review_date after translation check" do
    card.check_translation("face")
    expect(card.review_date).to eq(Date.today + 3.days)
  end
end
