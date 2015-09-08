module Sorcery
  module TestHelpers
    module Rails
      def login_user_post(user, password)
        page.driver.post(new_user_session, { username: user, password: password })
      end

      def logout_user_get
        page.driver.get(logout_url)
      end
    end
  end
end
