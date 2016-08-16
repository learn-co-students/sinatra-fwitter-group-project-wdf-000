module Helpers
  module InstanceMethods
    def logged_in?
      !!session[:user_id]
    end

    def current_user(session)
      User.find(session[:user_id])
    end

    def username_by_tweet(user_id)
      User.find(user_id).username
    end
  end
end