require "rails_helper"

describe Deck do
  it "when user is registered default deck added" do
    register_with("man@ohman.com", "123123", "123123")
    visit decks_path
    expect(page).to have_content "Default"
  end
end
