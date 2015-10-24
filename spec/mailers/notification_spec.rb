require 'rails_helper'

describe NotificationMailer do
  let!(:user) { create(:user, email: "slon@elephant.ru") }
  let!(:deck) { create(:deck, user: user) }
  let!(:card) { create(:card, original_text: "слон", translated_text: "elephant", deck: deck) }
  let(:user_with_counter) { User.for_review_counters.first }

  let(:mail) {
    NotificationMailer.cards_for_review_available(user_with_counter)
  }

  it "renders the subject" do
    expect(mail.subject).to eql("Cards for review available")
  end

  it "renders the receiver email" do
    expect(mail.to).to eql([user.email])
  end

  it "renders the sender email" do
    expect(mail.from).to eql([ENV["SENDMAIL_FROM"]])
  end
end
