module UserHelper
  def register_with(email, password, password_confirmation)
    visit new_registration_path
    within(".simple_form") do
      fill_in "user_email", with: email
      fill_in "user_password", with: password
      fill_in "user_password_confirmation", with: password_confirmation
    end
    click_button "Register"
  end

  def login_with(email, password)
    visit new_user_session_path
    within(".simple_form") do
      fill_in "user_sessions_email", with: email
      fill_in "user_sessions_password", with: password
    end
    click_button "Login"
  end

  def logout
    page.driver.submit :delete, logout_path, {}
  end

  def show_page_text
    puts page.text
  end

  def show_models_data(where)
    puts where + " All Cards("+Card.all.count.to_s+")"
    Card.all.each do |c|
      puts c.original_text + " @ " + c.deck.name + " of " + c.deck.user.email
    end

    puts where + " All Users("+User.all.count.to_s+")"
    User.all.each do |u|
      print u.email
      print "(" + u.current_deck.name + ")" if u.current_deck != nil
      print ":\n"
      u.decks.each do |d|
        d.cards.each do |c|
          puts "  Card " + c.original_text + " in deck " + d.name
        end
      end
    end

    puts where + " All Decks("+Deck.all.count.to_s+")"
    Deck.all.each do |d|
      puts "Deck named " + d.name + " of user " + d.user.email + " have cards:"
      d.cards.each do |c|
        puts c.original_text
      end
    end
  end
end

RSpec.configure do |config|
  config.include UserHelper, type: :feature
end
