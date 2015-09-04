require 'rails_helper'

describe Card do
  let!(:card) { create(:card) }

  it "right review" do
    visit new_review_path
    within(".simple_form") do
      fill_in "review_translated_text", with: "deer"
    end
    click_button "Check"
    expect(page).to have_content "Yes, you right!"
  end

  it "wrong review" do
    visit new_review_path
    within(".simple_form") do
      fill_in "review_translated_text", with: "diir"
    end
    click_button "Check"
    expect(page).to have_content "Nope, try again later!"
  end
end
