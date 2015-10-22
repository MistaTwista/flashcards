require "rails_helper"

describe Card do
  context "when review is right" do
    it 'answers "Yes, you right!"' do
      factory_card = create(:card)
      factory_card.deck.user.current_deck = factory_card.deck
      factory_card.deck.user.save
      login_with("example@example.com", "123123")
      visit new_review_path
      within(".simple_form") do
        fill_in "review_translated_text", with: "deer"
      end
      click_button "Check"
      expect(page).to have_content "Yes, you right!"
    end
  end

  context "when review if wrong" do
    it 'answers "Nope, try again later"' do
      factory_card = create(:card)
      factory_card.deck.user.current_deck = factory_card.deck
      factory_card.deck.user.save
      login_with("example@example.com", "123123")
      visit new_review_path
      within(".simple_form") do
        fill_in "review_translated_text", with: "diir"
      end
      click_button "Check"
      expect(page).to have_content "Nope, try again later!"
    end
  end
end
