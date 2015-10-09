require "rails_helper"
describe Card do
  let!(:card) { create(:card).update_attribute(:review_date, Date.today - 5.days) }

  it "right review" do
    # login_with("example@example.com", "123123")
    visit new_review_path
    within(".simple_form") do
      fill_in "review_translated_text", with: "deer"
    end
    click_button "Check"
    expect(page).to have_content "Yes, you right!"
  end

  it "wrong review" do
    # login_with("example@example.com", "123123")
    within(".simple_form") do
      fill_in "review_translated_text", with: "diir"
    end
    click_button "Check"
    expect(page).to have_content "Nope, try again later!"
  end
end
