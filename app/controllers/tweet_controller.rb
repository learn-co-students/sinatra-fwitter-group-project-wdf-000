class TweetController < Sinatra::Base
  include Helpers::InstanceMethods

  get '/tweets' do
    @user = current_user(session)
  end

end