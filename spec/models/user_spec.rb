require 'rails_helper'

describe User do
  it "shows hash of emails" do
    email_hash = User.email_list
    expect(email_hash.class.name).to eq("Hash")
  end
end
