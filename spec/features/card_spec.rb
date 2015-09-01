require 'rails_helper'

describe Card, type: :feature do
  let!(:card) { create(:card) }

  it "card checking" do
    visit new_review_path
    within(".simple_form") do
      fill_in 'review_translated_text', with: 'deer'
    end
    click_button "Check"
    expect(page).to have_content "Yes, you right!"
  end
end
