require 'rails_helper'

describe Card do

  context "valid false" do

    it "card without translation" do
      card = Card.new(original_text: "   Лицо ")
      expect(card).to be_invalid
    end

    it "card without original text" do
      card = Card.new(translated_text: " faCe ")
      expect(card).to be_invalid
    end

    it "card with original = translation" do
      card = Card.new(original_text: "    Face ", translated_text: " faCe ")
      expect(card).to be_invalid
    end

  end

  context "model functions" do

    let(:card) { create(:card) }

    it ".check_translation" do
      expect(card.check_translation("ifdnq02")).to be false
    end

    it ".review_date" do
      expect(card.review_date == Date.today + 3.days).to be true
    end

    it ".review_date after translation check" do
      card.check_translation("face")
      expect(card.review_date == Date.today + 3.days).to be true
    end

  end

end
