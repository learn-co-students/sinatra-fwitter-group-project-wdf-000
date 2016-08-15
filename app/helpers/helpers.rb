module Helpers
  module InstanceMethods
    def logged_in?(session)
      self.has_key?(session[:user_id])
    end

    def current_user(session)
      User.find(session[:user_id])
    end
  end
end