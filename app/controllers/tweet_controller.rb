class TweetController < ApplicationController
  include Helpers::InstanceMethods

  get '/tweets' do
    @user = current_user(session)
    erb :'/application/tweet'
  end

end