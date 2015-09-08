require "rails_helper"

describe User do
  it "create user" do
    register_with("josh@wink.com", "DASFI@", "DASFI@")
    expect(page).to have_content "josh@wink.com"
  end

  it "existing user" do
    register_with("josh@wink.com", "DASFI@", "DASFI@")
    register_with("josh@wink.com", "DASFI@", "DASFI@")
    expect(page).to have_content "has already been taken"
  end

  def register_with(email, password, password_confirmation)
    visit new_registration_path
    within(".simple_form") do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
    end
    expect(page).to have_content "josh@wink.com"
    click_button "Register"
  end
end
