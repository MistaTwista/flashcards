require "rails_helper"

describe User do
  it "create user" do
    register_with("josh@wink.com", "DASFI@")
    expect(page).to have_content "User: josh@wink.com"
  end

  it "existing user" do
    register_with("josh@wink.com", "DASFI@")
    register_with("josh@wink.com", "DASFI@")
    expect(page).to have_content "has already been taken"
  end

  def register_with(email, password)
    visit new_user_path
    within(".simple_form") do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
    end
    click_button "Create user"
  end
end
