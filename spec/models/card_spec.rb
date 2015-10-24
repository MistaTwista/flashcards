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
    expect(card.check_translation("ifdnq02")[:correct]).to be false
  end

  it "card after true translation" do
    Timecop.freeze(Time.now)
    card.check_translation("deer")
    expect(card.review_level).to eq(1)
    expect(card.error_counter).to eq(0)
    expect(card.review_date).to eq(Time.now + 12.hours)
    Timecop.return
  end

  it "card after false translation" do
    card.check_translation("deer")
    card.check_translation("deer")
    card.check_translation("diir")
    card.check_translation("diir")
    card.check_translation("diir")
    card.check_translation("diir")
    expect(card.review_level).to eq(1)
    expect(card.error_counter).to eq(0)
  end

  it 'sends notification "Cards for review available"' do
    User.notify_users_with_reviews_available
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
