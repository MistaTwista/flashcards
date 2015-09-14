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

  it "sees only self cards" do
    login_with("example@example.com", "123123")
    create(:card)
    logout
    register_with("man@ohman.com", "123123", "123123")
    visit cards_path
    expect(page).to have_no_content "deer"
  end
end
