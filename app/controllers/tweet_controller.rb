class TweetController < ApplicationController
  include Helpers::InstanceMethods

  get '/tweets' do
    if logged_in?
      @user = current_user(session)
      erb :'/users/tweet'
    else
      redirect '/login'
    end
  end

end