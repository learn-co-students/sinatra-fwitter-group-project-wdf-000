require 'sinatra/base'

module Helpers

  def current_user(session_info)
    @user = User.find_by_id(session_info["user_id"])
  end

  def is_logged_in?(session_info)
    !!session_info["user_id"]
  end

end
