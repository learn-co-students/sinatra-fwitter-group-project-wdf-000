class TweetController < ApplicationController
  include Helpers::InstanceMethods

  get '/tweets' do
    if logged_in?
      @user = current_user(session)
      erb :'/application/tweet'
    else
      redirect '/login'
    end
  end

end