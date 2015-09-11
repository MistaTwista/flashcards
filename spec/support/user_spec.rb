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
end

RSpec.configure do |config|
  config.include UserHelper, type: :feature
end
