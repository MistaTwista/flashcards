require "rails_helper"
describe Card do
  let!(:card) { create(:card).update_attribute(:review_date, Date.today - 5.days) }

  it "right review" do
    login
    visit new_review_path
    within(".simple_form") do
      fill_in "review_translated_text", with: "deer"
    end
    check
    expect(page).to have_content "Yes, you right!"
  end

  it "wrong review" do
    login
    within(".simple_form") do
      fill_in "review_translated_text", with: "diir"
    end
    check
    expect(page).to have_content "Nope, try again later!"
  end

  def login
    login_with("example@example.com", "123123")
  end

  def check
    click_button "Check"
  end
end
